terraform {
  backend "s3" {
    bucket         = "dhana-s3-demo-xyz" # change this
    key            = "terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}
