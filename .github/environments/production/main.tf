# Define the AWS provider
provider "aws" {
  region = "ap-south-1"
}

# Get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Get the default VPC's subnets in ap-south-1a
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

# Get the first subnet's details to use in the instance
data "aws_subnet" "first" {
  id = element(data.aws_subnets.default.ids, 0)
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
  subnet_id     = data.aws_subnet.first.id
  vpc_security_group_ids = [aws_security_group.strapi_sg.id]
  key_name = "ps_pd_a"

  user_data = <<-EOF
                #!/bin/bash
                sudo apt-get update
                sudo apt-get install -y git nodejs npm
                sudo npm install -g pm2
                cd /home/ubuntu

                # Configure Git
                git config --global user.name "arkajyotiadhikary"
                git config --global user.email "arkajyotiadhikary15@gmail.com"

                # Clone and setup the Strapi project using GitHub PAT
                GITHUB_PAT="${GITHUB_PAT}"
                git clone https://$GITHUB_PAT@github.com/PearlThoughts-DevOps-Internship/strapi.git
                cd strapi
                git checkout arka-prod

                # Ensure the correct permissions for the Git repository
                sudo chown -R ubuntu:ubuntu /home/ubuntu/strapi
                sudo chmod -R 755 /home/ubuntu/strapi

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
