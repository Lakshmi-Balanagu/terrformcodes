provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "my_instance" {
  instance_type = "t3.micro"
  ami = "ami-05fcfb9614772f051" # change this
}

// aws dynamodb create-table \
  --table-name terraform-lock \
  --billing-mode PAY_PER_REQUEST \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --region eu-north-1

// aws s3api create-bucket \
  --bucket my-unique-bucket-name \
  --region eu-north-1 \
  --create-bucket-configuration LocationConstraint=eu-north-1
