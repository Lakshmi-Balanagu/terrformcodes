# main.tf
provider "aws" {
  region = "us-east-1"
}

# Lookup tag values based on the workspace
locals {
  env      = terraform.workspace
  tag_map  = {
    dev  = "dev-team"
    prod = "ops-team"
  }

  owner_tag = lookup(local.tag_map, local.env, "unverified")
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 in us-east-1
  instance_type = "t2.micro"

  tags = {
    Name  = "instance-${local.env}"
    Owner = local.owner_tag
    Env   = local.env
  }
}
