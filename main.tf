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


# Configure the AWS Provider
provider "aws" {
  region     = "eu-north-1"
  access_key = "AKIATHVQLESRFC4KRUVV"
  secret_key = "lBLE4iSmD1Is0+LR/7LgRKnGoezARiF6wVfh5EV/"
}

# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}
