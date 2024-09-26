terraform {
  backend "s3" {
    bucket         = "terraformstates-1"
    key            = "state/terraform.tfstate"
    region         = "eu-north-1"
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

# Configure the AWS Provider2
provider "aws" {
  region     = "eu-north-1"
}

# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = "10.1.0.0/16"
}
