provider "aws" {
  region = "eu-north-1"
}
#Create key Pair
# 1. Generate SSH Key Pair
resource "tls_private_key" "generated_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# 2. Create AWS Key Pair using generated public key
resource "aws_key_pair" "my_key" {
  key_name   = "generated-web-key"
  public_key = tls_private_key.generated_key.public_key_openssh
}

# Create sg

resource "aws_security_group" "my_sg" {
  name        = "my_security_group"
  description = "Security group for my resources"
  vpc_id      =  "vpc-0adeab9bcd57b9130" # Replace with your VPC ID

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "MySecurityGroup"
    }
}

#Launch template
resource "aws_launch_template" "my_launch_template" {
  name ="mylaunchtemplate"
  image_id = "ami-05fcfb9614772f051"
  instance_type = "t3.micro"
  key_name = aws_key_pair.my_key.key_name
  #vpc_id = "vpc-0adeab9bcd57b9130"
  
  user_data = base64encode(<<-EOF
  #!/bin/bash
  yes > /dev/null &
EOF
)

network_interfaces {
    security_groups = [aws_security_group.my_sg.id]
    associate_public_ip_address = true
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "MyInstance"
    }
  }
  tags = {
    Name = "MyLaunchTemplate"
  }
  lifecycle {
    create_before_destroy = true
  } 
}

#Autoscaling group
resource "aws_autoscaling_group" "my_asg" {
  launch_template {
    id      = aws_launch_template.my_launch_template.id
    version = "$Latest"
  }
  min_size     = 1
  max_size     = 3
  desired_capacity = 2
  vpc_zone_identifier = ["subnet-0d1c5f3a348c00553"] # Replace with your subnet ID
   health_check_type         = "EC2"
  health_check_grace_period = 300
  force_delete              = true


  tag {
    key                 = "Name"
    value               = "MyAutoScalingGroup"
    propagate_at_launch = true
  }

}

#Scale up policy
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale_up_policy"
  scaling_adjustment      = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
}

#6. CloudWatch Alarm for CPU spike
resource "aws_cloudwatch_metric_alarm" "cpu_spike_alarm" {
  alarm_name          = "cpu_spike_alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.my_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_up.arn]
} 
