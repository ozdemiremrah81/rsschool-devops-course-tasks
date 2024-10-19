# Bastion Host EC2 Instance
resource "aws_instance" "bastion_host" {
  ami           = "ami-097c5c21a18dc59ea"  # Amazon Linux 2 AMI, change based on region
  instance_type = var.instance_type              # Choose instance type
  subnet_id     = aws_subnet.app1_publicsubnet1.id  # Launch in a public subnet

  # Use your key pair for SSH access
  key_name      = "aws_key_pair.k3s-key"  # Use your key pair for SSH (optional)

  # Attach the public Security Group
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  associate_public_ip_address = true  # Ensure public IP for SSH access

  tags = {
    Name = "Bastion Host"
  }
}

# K3S Instance 1 in public subnet
resource "aws_instance" "k3s_instance1" {
  ami           = "ami-000e50175c5f86214"  # Ubuntu 22.04 north eu
  instance_type = var.instance_type              # Choose instance type
  subnet_id     = aws_subnet.app1_publicsubnet2.id  # Public subnet2

  key_name      = "aws_key_pair.k3s-key"  # Use your key pair for SSH (optional)

  # Attach the private Security Group
  vpc_security_group_ids = [aws_security_group.k3s_sg.id]

  associate_public_ip_address = true  # Ensure public IP for SSH access

  tags = {
    Name = "k3s-Instance1"
  }

 user_data = <<-EOF
              #!/bin/bash
              curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644 --tls-san $(curl http://169.254.169.254/latest/meta-data/public-ipv4)
              EOF

  # Attach the key pair to the instance for SSH access
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.k3s_key.private_key_pem
    host        = self.public_ip
  }
   # Output the public IP of the EC2 instance after creation
  provisioner "local-exec" {
    command = "echo 'k3s server running on: ${self.public_ip}'"
  }


}

# Output the private key to access the instance
output "private_key" {
  value     = tls_private_key.k3s_key.private_key_pem
  sensitive = true
}

# Output the EC2 instance public IP
output "instance_ip" {
  value = aws_instance.k3s_instance1.public_ip
}