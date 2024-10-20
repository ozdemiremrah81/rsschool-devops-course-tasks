# Define AWS region as a variable
variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "eu-north-1"
}

#add your home/office's public ip here
variable "AllowedIP" {
  description = "Allowed IP for connecting to the bastion host"
  type        = string
  default     = "88.238.64.27/32" # Replace with your IP range (office/home IP)
}

#AWS EC2 instance type
variable "instance_type" {
  description = "EC2 instance type for k3s"
  default     = "t3.micro"
}

# Define VPC and Subnets CIDR block as a variable
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.1.0.0/21"
}

variable "private_subnet1_cidr" {
  description = "The CIDR block for private subnet1"
  type        = string
  default     = "10.1.1.0/24"
}

variable "private_subnet2_cidr" {
  description = "The CIDR block for private subnet2"
  type        = string
  default     = "10.1.2.0/24"
}

variable "public_subnet1_cidr" {
  description = "The CIDR block for public subnet1"
  type        = string
  default     = "10.1.6.0/24"
}

variable "public_subnet2_cidr" {
  description = "The CIDR block for public subnet2"
  type        = string
  default     = "10.1.7.0/24"
}

#Availability zones
variable "AZ1a" {
  description = "The availabilityzone1"
  type        = string
  default     = "eu-north-1a"
}

variable "AZ1b" {
  description = "The availabilityzone2"
  type        = string
  default     = "eu-north-1b"
}