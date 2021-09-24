output "bucket_name" {
  value       = aws_s3_bucket.bucket.id
  description = "AWS S3 Bucket Name"
}

output "bucket_arn" {
  value       = aws_s3_bucket.bucket.arn
  description = "AWS S3 Bucket arn"
}

output "bucket_regional_domain_name" {
  value       = aws_s3_bucket.bucket.bucket_regional_domain_name
  description = "AWS S3 Bucket regional domain name"
}