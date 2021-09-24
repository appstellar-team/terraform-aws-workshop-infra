provider "aws" {
  region     = "eu-central-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

locals {
  buckets = toset([
    "bucket-1",
    "bucket-2",
  ])
}


resource "aws_s3_bucket" "bucket" {
    for_each = local.buckets
  bucket = format("appstellar-terraform-workshop-%s", each.key)
}