provider "aws" {
  region     = "eu-central-1"
  access_key = var.access_key
  secret_key = var.secret_key
}


module "lambda_function_existing_package_local" {
  source = "terraform-aws-modules/lambda/aws"
  version        = "~> 2.0"
  function_name = "appstellar-terraform-workshop-lambda-test"
  handler       = "index.handler"
  runtime  = "nodejs12.x"

  create_package         = false
  local_existing_package = "./lambda.zip"
}