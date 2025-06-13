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
