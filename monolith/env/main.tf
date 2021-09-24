# Set a Terraform required version.
terraform {
  required_version = ">= 1.0"
  backend "local" {}

}


# Authenticate to a cloud provider. In our case it is AWS.
provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}


#######################################################
# Provisioning React Web Client AWS Resources
#######################################################

# Creates a S3 Bucket resource.
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "appstellar-terraform-workshop-s3-v1"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": {
        "CanonicalUser": "${aws_cloudfront_origin_access_identity.origin_access_identity.s3_canonical_user_id}"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::appstellar-terraform-workshop-s3-v1/*"
    }
  ]
}
EOF

  # Enable versioning so we can see the full revision history of our state files
  versioning {
    enabled = true
  }

  acl = "private"

  force_destroy = false

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = {
    Environment = "dev"
  }
}


resource "aws_s3_bucket_public_access_block" "s3_bucket_acl" {
  bucket                  = aws_s3_bucket.s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Creates a CloudFront Origin Access Identity to access S3 Bucket
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "A CDN origin access identity"
}

# Creates a CloudFront Distribution
resource "aws_cloudfront_distribution" "cdn_distribution" {

  origin {
    origin_id   = "s3_origin"
    domain_name = aws_s3_bucket.s3_bucket.bucket_regional_domain_name
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3_origin"

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }

  custom_error_response {
    error_caching_min_ttl = "10"
    error_code            = "403"
    response_code         = "200"
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = "10"
    error_code            = "404"
    response_code         = "404"
    response_page_path    = "/404.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  price_class = "PriceClass_All"

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Environment = "dev"
  }
}



#####################################################################################
# Provisioning Back-End AWS Resources such as API Gateway and Lambda function
#####################################################################################

resource "aws_lambda_function" "lambda_function" {
  function_name = "appstellar-terraform-workshop-lambda"

  filename = "lambda.zip"
  handler  = "index.handler"
  runtime  = "nodejs12.x"

  role = aws_iam_role.lambda_role.arn

  tags = {
    Environment = "dev"
  }
}

# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "lambda_role" {
  name = "role_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_api_gateway_rest_api" "api_gtw" {
  name = "appstellar-terraform-workshop-api-gtw"

  tags = {
    Environment = "dev"
  }
}



resource "aws_api_gateway_resource" "test_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gtw.id
  parent_id   = aws_api_gateway_rest_api.api_gtw.root_resource_id
  path_part   = "test"
}

resource "aws_api_gateway_method" "test_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.api_gtw.id
  resource_id   = aws_api_gateway_resource.test_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.api_gtw.id
  resource_id = aws_api_gateway_method.test_get_method.resource_id
  http_method = aws_api_gateway_method.test_get_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function.invoke_arn
}



resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration,
  ]

  rest_api_id = aws_api_gateway_rest_api.api_gtw.id
  stage_name  = "dev"
}


resource "aws_lambda_permission" "api_gtw_invoke_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.api_gtw.execution_arn}/*/*"
}


output "base_url" {
  value = aws_api_gateway_deployment.api_deployment.invoke_url
}
