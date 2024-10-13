resource "aws_subnet" "app1_privatesubnet1" {
  vpc_id            = aws_vpc.app1_vpc.id
  cidr_block        = var.private_subnet1_cidr
  availability_zone = var.AZ1a
  }
  resource "aws_subnet" "app1_privatesubnet2" {
  vpc_id            = aws_vpc.app1_vpc.id
  cidr_block        = var.private_subnet2_cidr
  availability_zone = var.AZ1b
}