# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = var.vpc_cidr_block
}
