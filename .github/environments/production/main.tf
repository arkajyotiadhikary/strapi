provider "aws" {
  region = "ap-south-1"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = ["ap-south-1b"]
  }
}

data "aws_subnet" "first" {
  id = element(data.aws_subnets.default.ids, 0)
}

resource "aws_security_group" "strapi_sg" {
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "strapi-sg"
  }
}

data "aws_instance" "existing" {
  filter {
    name   = "tag:Name"
    values = ["ar-strapi-instance"]
  }

  filter {
    name   = "instance-state-name"
    values = ["running", "pending"]
  }
}

resource "aws_instance" "ar_strapi_docker" {
  count = length(data.aws_instance.existing.ids) == 0 ? 1 : 0

  ami           = "ami-0f58b397bc5c1f2e8"
  instance_type = "t2.medium"
  subnet_id     = data.aws_subnet.first.id
  vpc_security_group_ids = [aws_security_group.strapi_sg.id]
  key_name = "ps_pd_a"

  user_data = file("user_data.sh")

  tags = {
    Name = "ar-strapi-instance"
  }
}

output "instance_public_ip" {
  value = length(data.aws_instance.existing.ids) == 0 ? aws_instance.ar_strapi_docker[0].public_ip : data.aws_instance.existing.instances[0].public_ip
}

output "instance_id" {
  value = length(data.aws_instance.existing.ids) == 0 ? aws_instance.ar_strapi_docker[0].id : data.aws_instance.existing.instances[0].id
}
