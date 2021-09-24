# Set AWS provider, region and access keys
provider "aws" {
  region     = "eu-central-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

data "aws_s3_bucket" "selected" {
  bucket = "terraform-workshop-tali-test"
}

output "bucket_domain_name" {
  value       = data.aws_s3_bucket.selected.bucket_domain_name
}