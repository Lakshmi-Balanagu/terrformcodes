
provider "aws" {
  region = "eu-north-1"
}

# Read existing bucket list from JSON file (or fallback to empty list)
locals {
  existing_buckets_json = fileexists("${path.module}/bucket_names.json") ? file("${path.module}/bucket_names.json") : "[]"
  existing_buckets       = jsondecode(local.existing_buckets_json)

  updated_buckets = (var.create_s3 && var.new_bucket_name != "") ? concat(local.existing_buckets, [var.new_bucket_name]) : local.existing_buckets
}

resource "aws_s3_bucket" "buckets" {
  for_each      = toset(local.updated_buckets)
  bucket        = "my-dynamic-bucket-${each.key}"
  force_destroy = true

  tags = {
    Name        = "UserBucket-${each.key}"
    Environment = "Dev"
  }
}

resource "local_file" "save_bucket_names" {
  content  = jsonencode(local.updated_buckets)
  filename = "${path.module}/bucket_names.json"
}

output "all_buckets" {
  value = [for b in aws_s3_bucket.buckets : b.bucket]
}
