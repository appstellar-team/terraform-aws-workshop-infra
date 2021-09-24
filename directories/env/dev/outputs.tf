output "bucket_name" {
  value       = module.bucket.bucket_name
  description = "AWS S3 Bucket Name"
}

output "bucket_arn" {
  value       = module.bucket.bucket_arn
  description = "AWS S3 Bucket arn"
}

output "bucket_regional_domain_name" {
  value       = module.bucket.bucket_regional_domain_name
  description = "AWS S3 Bucket regional domain name"
}