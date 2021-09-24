module "iam_user" {
  source      = "../modules/iam"
  name        = "terraform_workshop_user"
  environment = var.environment
}
