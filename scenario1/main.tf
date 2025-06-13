provider "aws"{
    region = "eu-north-1"

}
resource "aws_instance" "example"{
  count = terraform.workspace == "dev" ? 3 : terraform.workspace == "staging" ? 3 : terraform.workspace == "prod" ? 3 : 0
    ami = "ami-05fcfb9614772f051"
    instance_type = "t3.micro"
    tags = {
        Name = "${terraform.workspace}-instance-${count.index}"
        Environment = terraform.workspace
    }
} 
