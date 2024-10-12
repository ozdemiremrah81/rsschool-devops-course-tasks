output "bastion_public_ip" {
  value = aws_instance.bastion_host.public_ip
}

output "private_instance1_private_ip" {
  value = aws_instance.private_instance1.private_ip
}
