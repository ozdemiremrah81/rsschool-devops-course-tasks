resource "aws_subnet" "app1_publicsubnet1" {
  vpc_id            = aws_vpc.app1_vpc.id
  cidr_block        = "10.1.6.0/24"
  availability_zone = "eu-north-1a"  # Change based on your region
  }
  resource "aws_subnet" "app1_publicsubnet2" {
  vpc_id            = aws_vpc.app1_vpc.id
  cidr_block        = "10.1.7.0/24"
  availability_zone = "eu-north-1b"  # Different AZ
}