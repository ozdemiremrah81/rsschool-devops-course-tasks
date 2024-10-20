# Security Group for Bastion Host (Public access)
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow SSH from specific IPs"
  vpc_id      = aws_vpc.app1_vpc.id

 # SSH Ingress Rule
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.AllowedIP]
  }
 # ICMP (Ping) Ingress Rule
  ingress {
    description = "Allow all ICMP traffic (Ping)"
    from_port   = -1  # -1 means all types of ICMP messages
    to_port     = -1  # -1 allows all codes for ICMP
    protocol    = "icmp"
    cidr_blocks = ["10.1.0.0/21"]  # Allow from vpc
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }
}

# Security Group for k3s Instances 
resource "aws_security_group" "k3s_sg" {
  name        = "k3s-sg"
  description = "Allow SSH only from Bastion Host"
  vpc_id      = aws_vpc.app1_vpc.id

  ingress {
    description = "Allow SSH from Bastion Host"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.AllowedIP]
    #security_groups = [aws_security_group.bastion_sg.id]  # Allow access from Bastion SG
  }
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Kubernetes API access (can be restricted)
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # HTTP access for services (optional)
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # HTTPS access for services (optional)
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }
}
