# modules/ec2/variables.tf
variable "ami_id" {
  description = "AMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID"
  type        = string
}

variable "key_name" {
  description = "Key pair name"
  type        = string
}

variable "user" {
  description = "SSH user"
  type        = string
}

variable "private_key_path" {
  description = "Path to the private key file"
  type        = string
}

variable "availability_zone" {
  description = "value of availability zone"
  type        = string
}

variable "docker_username" {
  description = "Docker username"
  type        = string
}

variable "docker_password" {
  description = "Docker password"
  type        = string
}
