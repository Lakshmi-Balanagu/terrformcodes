variable "vpc_configs"{
    type = map(object({
        vpc_name            = string
        vpc_cidr            = string
        public_subnet_cidrs = list(string)
        private_subnet_cidrs = list(string)
        enable_nat_gateway  = optional(bool, false)
    }))
}
variable "region" {
  default = "eu-north-1"
}
[root@ip-172-31-29-160 scenario2]# cat terraform.tfvars 
vpc_configs = {
  vpc_1 = {
    vpc_name             = "vpc-1"
    vpc_cidr             = "10.0.0.0/16"
    public_subnet_cidrs  = ["10.0.1.0/24"]
    private_subnet_cidrs = ["10.0.2.0/24"]
    enable_nat_gateway   = true
  }

  vpc_2 = {
    vpc_name             = "vpc-2"
    vpc_cidr             = "10.1.0.0/16"
    public_subnet_cidrs  = ["10.1.1.0/24"]
    private_subnet_cidrs = ["10.1.2.0/24"]
    enable_nat_gateway   = true
  }
}
region = "eu-north-1"
