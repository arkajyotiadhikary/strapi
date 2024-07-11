resource "aws_security_group" "sgforreact" {
  vpc_id      = var.vpc_id
  description = "This is for strapy application"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sgforreact"
  }
  depends_on = [aws_security_group.sgforreact]
}

data "aws_ami" "ubuntu2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] 
}

resource "aws_instance" "ec2fornginxreact" {
  ami                         = data.aws_ami.ubuntu2.id
  availability_zone           = "ap-south-1a"
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.sgforreact.id]
  subnet_id                   = var.subnet_ids[0]
  key_name                    = var.key_name
  associate_public_ip_address = true
  ebs_block_device {
    device_name           = "/dev/sdh"
    volume_size           = 20
    volume_type           = "gp2"
    delete_on_termination = true
  }
  tags = {
    Name = "nginxreact"
  }

  user_data = <<-EOF
    #!/bin/bash
    set -e
    sudo apt-get update
    sudo apt-get install -y nginx

    # Configure Nginx site
    sudo tee /etc/nginx/sites-available/strapi > /dev/null <<EOT
    server {
        listen 80;
        server_name arka.contentecho.in;

        location / {
            proxy_pass http://${aws_lb.strapi_lb.dns_name}:3000;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
    }
    EOT

    # Enable and configure the site
    sudo ln -s /etc/nginx/sites-available/strapi /etc/nginx/sites-enabled/default

    # Restart Nginx to apply changes
    sudo systemctl restart nginx
  EOF
  depends_on = [aws_security_group.sgforreact]
}

