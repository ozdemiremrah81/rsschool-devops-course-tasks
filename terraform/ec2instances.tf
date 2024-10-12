# Bastion Host EC2 Instance
resource "aws_instance" "bastion_host" {
  ami           = "ami-0a91cd140a1fc148a"  # Amazon Linux 2 AMI, change based on region
  instance_type = "t3.micro"               # Choose instance type
  subnet_id     = aws_subnet.app1_publicsubnet1.id  # Launch in a public subnet

  # Use your key pair for SSH access
  key_name      = "app1_natgw_keypair"  # Replace with your key pair name

  # Attach the public Security Group
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  associate_public_ip_address = true  # Ensure public IP for SSH access

  tags = {
    Name = "Bastion Host"
  }
}

# Private Instance 1 in private subnet
resource "aws_instance" "private_instance1" {
  ami           = "ami-0a91cd140a1fc148a"  # Amazon Linux 2 AMI, change based on region
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.app1_privatesubnet1.id  # Private subnet 1

  key_name      = "app1_natgw_keypai"  # Use your key pair for SSH (optional)

  # Attach the private Security Group
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  tags = {
    Name = "Private Instance 1"
  }
}