
# K3S MasterNode in private subnet1
resource "aws_instance" "k3s_masternode" {
  ami           = "ami-000e50175c5f86214"  # Ubuntu 22.04 north eu
  instance_type = var.instance_type              # Choose instance type
  subnet_id     = aws_subnet.app1_publicsubnet1.id  # private subnet1

  key_name      = "app1_natgw_keypair"  # Use your key pair for SSH (optional)

  # Attach the private Security Group
  vpc_security_group_ids = [aws_security_group.k3s_sg.id]

  tags = {
    Name = "k3s-masternode"
  }

 user_data = <<-EOF
              #!/bin/bash
              curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644 --tls-san $(curl http://169.254.169.254/latest/meta-data/public-ipv4)
              EOF

  # Attach the key pair to the instance for SSH access
  #connection {
    #type        = "ssh"
    #user        = "ubuntu"
    #private_key = tls_private_key.k3s_key.private_key_pem
    #host        = self.public_ip
  #}
   # Output the public IP of the EC2 instance after creation
  #provisioner "local-exec" {
   # command = "echo 'k3s server running on: ${self.public_ip}'"
  #}


}

# Output the private key to access the instance
#output "private_key" {
  #value     = tls_private_key.k3s_key.private_key_pem
  #sensitive = true
#}
resource "aws_instance" "k3s_agent" {
  ami           = "ami-000e50175c5f86214"  # Ubuntu 22.04 north eu
  instance_type = var.instance_type              # Choose instance type
  subnet_id     = aws_subnet.app1_publicsubnet1.id  # private subnet1

  key_name      = "app1_natgw_keypair"  # Use your key pair for SSH (optional)

  # Attach the private Security Group
  vpc_security_group_ids = [aws_security_group.k3s_sg.id]

  tags = {
    Name = "k3s-agent"
  }
}