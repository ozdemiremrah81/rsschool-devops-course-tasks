# Create a VPC
resource "aws_vpc" "app1_vpc" {
  cidr_block = var.vpc_cidr_block
}
