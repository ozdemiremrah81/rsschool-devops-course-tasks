resource "aws_internet_gateway" "app1_igw" {
  vpc_id = aws_vpc.app1_vpc.id
}