output "vpc_id" {
  value = aws_vpc.sc2_vpc.id
}

output "public_subnet_ids" {
  value = [for subnet in aws_subnet.sc2_public : subnet.id]
}

output "private_subnet_ids" {
  value = [for subnet in aws_subnet.sc2_private : subnet.id]
}
