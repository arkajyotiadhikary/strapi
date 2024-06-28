variable "ami" {
  description = "The AMI ID to use for the instance"
  type        = string
}

variable "availability_zone" {
  description = "The availability zone to deploy the instance in"
  type        = string
}

variable "instance_type" {
  description = "The instance type to use"
  type        = string
  default     = "t2.micro"
}

variable "vpc_security_group_ids" {
  description = "Security Group IDs for the instance"
  type        = list(string)
}

variable "subnet_id" {
  description = "Subnet ID for the instance"
  type        = string
}

variable "key_name" {
  description = "Key pair name to access the instance"
  type        = string
}

variable "docker_username" {
  description = "Docker Hub username"
  type        = string
}

variable "docker_password" {
  description = "Docker Hub password"
  type        = string
  sensitive   = true
}

variable "user" {
  description = "The SSH user to connect to the instance"
  type        = string
}

variable "privatekey" {
  description = "The private key for SSH access"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
}

variable "aws_access_key_id" {
  description = "AWS Access Key ID"
  type        = string
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key"
  type        = string
  sensitive   = true
}
