# Generate an SSH key pair
resource "tls_private_key" "k3s_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "k3s_key_pair" {
  key_name   = "k3s-key"
  public_key = tls_private_key.k3s_key.public_key_openssh
}