variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet ID"
  type        = list(string)
}

variable "sg_id" {
  description = "ID of the existing security group"
  type        = string
}

variable "domain_name" {
  description = "value of the domain name"
  type        = string
}

variable "project_name" {
  description = "The project name"
  type = string
  default = "ar-strapi"
}

variable "sub_domain" {
  description = "The subdomain to assign to the ecs service"
  type = string
  default = "arka.contentecho.in"
}

variable "hosted_zone_id" {
  description = "The route 53 hosted zone id"
  type = string
  default = "Z06607023RJWXGXD2ZL6M"
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["38.0.101.0/24", "89.0.142.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}
variable "vpc_cidr" {
  description = "List of availability zones"
  type        = string
  default     = "38.0.0.0/16"
}
