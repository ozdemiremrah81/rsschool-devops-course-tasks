terraform {
  backend "s3" {
    bucket         = "terraformstates-1"
    key            = "state/terraform.tfstate"
    region         = var.region
    encrypt        = true
    dynamodb_table = "tf_lock"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider using the variable for the region
provider "aws" {
  region = var.region
}
