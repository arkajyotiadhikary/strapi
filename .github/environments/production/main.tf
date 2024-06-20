# Define the AWS provider
provider "aws" {
  region = "ap-south-1"
}

# Define the VPC
resource "aws_vpc" "ar_strapi_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "ar-strapi-vpc"
  }
}

# Define a public subnet
resource "aws_subnet" "ar_strapi_subnet" {
  vpc_id            = aws_vpc.ar_strapi_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "ar-strapi-subnet"
  }
}

# Define an internet gateway
resource "aws_internet_gateway" "ar_strapi_igw" {
  vpc_id = aws_vpc.ar_strapi_vpc.id
  tags = {
    Name = "ar-strapi-igw"
  }
}

# Define a route table
resource "aws_route_table" "ar_strapi_route_table" {
  vpc_id = aws_vpc.ar_strapi_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ar_strapi_igw.id
  }
  tags = {
    Name = "ar-strapi-route-table"
  }
}

# Associate the route table with the subnet
resource "aws_route_table_association" "ar_strapi_route_table_assoc" {
  subnet_id      = aws_subnet.ar_strapi_subnet.id
  route_table_id = aws_route_table.ar_strapi_route_table.id
}

# Define a security group
resource "aws_security_group" "ar_strapi_sg" {
  vpc_id = aws_vpc.ar_strapi_vpc.id
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
  subnet_id     = aws_subnet.ar_strapi_subnet.id
  security_groups = [aws_security_group.ar_strapi_sg.name]
  key_name = "ps_pd_a"

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
