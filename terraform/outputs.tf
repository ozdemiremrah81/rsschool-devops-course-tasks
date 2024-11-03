output "k3s_masternode_public_ip" {
  value = aws_instance.k3s_masternode.public_ip
}

# outputs.tf

#output "k3s_ssh_private_key" {
  #description = "Private key for SSH access to the k3s instance"
  #value       =  tls_private_key.k3s_key.private_key_pem
  #sensitive   = true
#}

output "kubeconfig_file" {
  description = "The path to the kubeconfig file to access the k3s cluster"
  value       = "/etc/rancher/k3s/k3s.yaml"
}
