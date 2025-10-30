# After the S3 bucket is created, copy this file to your root module
# Backend configuration - uncomment after bucket is created
# terraform {
#   backend "s3" {
#     bucket         = "my-s3-bucket-eu-west-2"
#     key            = "terraform.tfstate"
#     region         = "eu-west-2"  # London region
#     encrypt        = true
#   }
# }