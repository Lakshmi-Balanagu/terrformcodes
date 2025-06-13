provider "aws" {
  region = var.region
}


module "vpc" {
    for_each = var.vpc_configs
    source = "./modules/vpc"

    region = var.region
    vpc_name = each.value.vpc_name
    vpc_cidr = each.value.vpc_cidr  
    public_subnet_cidrs = each.value.public_subnet_cidrs
    private_subnet_cidrs = each.value.private_subnet_cidrs
    enable_nat_gateway = each.value.enable_nat_gateway
}
