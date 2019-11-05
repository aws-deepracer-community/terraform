// Configure AWS provider
provider "aws" {
  version                 = "~> 2.32"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "deepracer"
  region                  = var.region
}

// Configure S3 to hold terraform state
terraform {
  backend "s3" {
    bucket  = "deepracing-terraform-artifacts"
    key     = "deepracing/terraform.tfstate"
    profile = "deepracer"
    region  = "eu-west-1"
  }
}
