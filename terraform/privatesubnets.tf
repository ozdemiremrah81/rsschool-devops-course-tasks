resource "aws_subnet" "app1_private_subnet1" {
  vpc_id            = aws_vpc.app1_vpc.id
  cidr_block        = "10.2.1.0/24"
  availability_zone = "eu-north-1a"  # Change based on your region
  }
  resource "aws_subnet" "app1_private_subnet2" {
  vpc_id            = aws_vpc.app1_vpc.id
  cidr_block        = "10.2.2.0/24"
  availability_zone = "eu-north-1b"  # Different AZ
}