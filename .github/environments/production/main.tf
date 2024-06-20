# Define the AWS provider
provider "aws" {
  region = "ap-south-1"
}

# Get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Get the default VPC's subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Define a security group
resource "aws_security_group" "strapi_sg" {
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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

# Define the EC2 instance
resource "aws_instance" "ar_strapi_instance" {
  ami           = "ami-0f58b397bc5c1f2e8"
  instance_type = "t2.micro"
  subnet_id     = element(data.aws_subnets.default.ids, 0)
  vpc_security_group_ids = [aws_security_group.strapi_sg.id]
  key_name = "ps_pd_a"  # Replace with your key pair name

  user_data = <<-EOF
                #!/bin/bash
                sudo apt-get update
                sudo apt-get install -y nodejs npm
                sudo npm install -g pm2
                cd /home/ubuntu
                git clone https://github.com/PearlThoughts-DevOps-Internship/strapi.git
                git checkout arka-prod
                cd strapi
                npm install
                npm run build
                pm2 start npm --name "strapi" -- run start
                pm2 save
                EOF

  tags = {
    Name = "ar-strapi-instance"
  }
}

# Output the public IP of the instance
output "instance_public_ip" {
  value = aws_instance.ar_strapi_instance.public_ip
}

# Output the instance ID
output "instance_id" {
  value = aws_instance.ar_strapi_instance.id
}
