# Create an S3 bucket used to store the terraform state
resource "aws_s3_bucket" "bucket" {
  bucket = var.name
  # Enable versioning so we can see the full revision history of our state files
  versioning {
    enabled = var.sse_enabled
  }

  acl = var.acl

  force_destroy = var.force_destroy

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = var.sse_algorithm
      }
    }
  }
  tags = var.tags
}



resource "aws_s3_bucket_public_access_block" "bucket_acl" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}