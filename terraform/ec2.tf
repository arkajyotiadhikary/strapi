# variable "private_key" {
#   description = "Private SSH key for provisioning"
#   type        = string
#   sensitive   = true
# }

# variable "instance_name" {
#   description = "Name of the EC2 instance"
#   type        = string
#   default     = "ar-strapi"
# }

# resource "aws_instance" "ar-strapi" {
#   ami           = "ami-0f58b397bc5c1f2e8"
#   instance_type = var.instance_type
#   key_name      = var.key_name
#   subnet_id     = var.subnet_id
#   vpc_security_group_ids = [var.sg_id]  # Reference the security group by ID

#   tags = {
#     Name = var.instance_name
#   }

#   user_data = <<-EOF
#               #!/bin/bash
#               # Update the package index
#               sudo apt update -y

#               # Install Node.js, npm, and git
#               sudo apt install -y nodejs npm git

#               # Install PM2 globally
#               sudo npm install -g pm2

#               # Create directory for Strapi
#               mkdir -p /var/www

#               # Navigate to the directory
#               cd /var/www

#               # Clone the repository
#               git clone https://github.com/arkajyotiadhikary/ContentEcho.git

#               # Navigate to the repository
#               cd ContentEcho

#               # Install dependencies
#               npm install
#               EOF
# }

# resource "null_resource" "provision" {
#   depends_on = [aws_instance.ar-strapi]

#   connection {
#     type        = "ssh"
#     host        = aws_instance.ar-strapi.public_ip
#     user        = "ubuntu"
#     private_key = var.private_key
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "echo 'Running remote-exec provisioner'",
#       "cd /var/www/ContentEcho",
#       "pm2 start npm --name 'strapi' -- run develop",
#       "pm2 save",
#       "pm2 startup systemd -u $(whoami) --hp /home/$(whoami)",
#       "sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u $(whoami) --hp /home/$(whoami)"
#     ]
#   }
# }
