variable "regions" {
  type    = list(string)
  default = ["us-east-1", "us-west-2", "eu-central-1"]
}

provider "aws" {
  alias  = "default"
  region = "us-east-1" # default region
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us-west-2"
  region = "us-west-2"
}

provider "aws" {
  alias  = "eu-central-1"
  region = "eu-central-1"
}

module "cloudwatch_dashboard" {
  for_each = toset(var.regions)

  source   = "./modules/dashboard"
  region   = each.key
  providers = {
    aws = aws.${each.key}
  }
}
