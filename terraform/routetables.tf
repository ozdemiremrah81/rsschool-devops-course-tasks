resource "aws_route_table" "app1_public_rt" {
  vpc_id = aws_vpc.app1_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app1_igw.id
  }
}
resource "aws_route_table_association" "app1_public_rt_assoc1" {
  subnet_id      = aws_subnet.app1_publicsubnet1.id
  route_table_id = aws_route_table.app1_public_rt.id
}

resource "aws_route_table_association" "app1_public_rt_assoc2" {
  subnet_id      = aws_subnet.app1_publicsubnet2.id
  route_table_id = aws_route_table.app1_public_rt.id
}