variable "aws_access_key" {
  description = "AWS Access Key ID"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS Secret Access Key"
  type        = string
}

variable "user" {
  description = "SSH user"
  type        = string
}

variable "privatekey" {
  description = "SSH Private Key"
  type        = string
}

variable "docker_username" {
  description = "Docker Hub Username"
  type        = string
}

variable "docker_password" {
  description = "Docker Hub Password"
  type        = string
}
