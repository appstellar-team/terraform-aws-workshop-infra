# Create S3 Bucket
module "bucket" {
  source      = "../../modules/s3"
  name                    = format("%s-%s", var.bucket_name, var.environment)
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  tags                    =  {
    environment = var.environment
  }
}
