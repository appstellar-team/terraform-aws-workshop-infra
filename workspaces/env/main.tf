# Create S3 Bucket
module "bucket" {
  source                  = "../../modules/s3"
  name                    = format("%s-%s", var.bucket_name, var.environment)
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  tags = {
    environment = var.environment
  }
}


module "bucket_two" {
  source = "../../modules/s3"
  name   = format("%s-%s-sample", var.bucket_name, var.environment)
  tags = {
    environment = var.environment
    author      = "tali"
  }
}

module "bucket_three" {
  source = "../../modules/s3"
  name   = format("%s-%s-tali", var.bucket_name, var.environment)
  tags = {
    environment = var.environment
    author      = "tali"
  }
}