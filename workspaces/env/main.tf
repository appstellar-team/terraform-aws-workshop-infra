module "iam_user" {
  source      = "./modules/iam"
  name        = "s3_bucket_user"
  environment = var.environment
  bucket      = var.s3_bucket_name
}
