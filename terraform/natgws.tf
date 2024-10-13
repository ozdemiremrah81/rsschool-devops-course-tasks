resource "aws_eip" "nat_eip" {
  vpc = true
}
resource "aws_nat_gateway" "app1_nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.app1_publicsubnet1.id  # Public subnet to place NAT Gateway
}