provider "aws" {
  region     = "eu-central-1"
  access_key = var.access_key
  secret_key = var.secret_key
  alias = "dev"
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
  alias = "prod"
}

resource "aws_s3_bucket" "dev_bucket" {
  bucket = "appstellar-terraform-workshop-multiple-provider-dev"
  provider = aws.dev
}

output "dev_bucket_regional_domain_name" {
  value       = aws_s3_bucket.dev_bucket.bucket_regional_domain_name
  description = "AWS S3 Bucket regional domain name"  
}

resource "aws_s3_bucket" "prod_bucket" {
  bucket = "appstellar-terraform-workshop-multiple-provider-prod"
  provider = aws.prod
}

output "prod_bucket_regional_domain_name" {
  value       = aws_s3_bucket.prod_bucket.bucket_regional_domain_name
  description = "AWS S3 Bucket regional domain name"
}