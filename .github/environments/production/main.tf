resource "aws_instance" "arka_strapi" {
  ami                         = var.ami
  availability_zone           = var.availability_zone
  instance_type               = var.instance_type
  vpc_security_group_ids      = var.vpc_security_group_ids
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              {
                sudo apt update
                if ! command -v docker &> /dev/null; then
                  sudo apt install docker.io -y
                  sudo usermod -aG docker ${var.user}
                  sudo chmod 660 /var/run/docker.sock
                fi
                echo "${var.docker_password}" | docker login -u "${var.docker_username}" --password-stdin
              } >> /var/log/user-data.log 2>&1
              EOF

  ebs_block_device {
    device_name           = "/dev/sdh"
    volume_size           = 20
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = "arka_strapi"
  }
}

resource "null_resource" "example" {
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = var.user
      private_key = var.privatekey
      host        = aws_instance.arka_strapi.public_ip
    }
    inline = [
      "git clone https://github.com/arkajyotiadhikary/strapi.git -b arka-prod",
      "cd strapi",
      "docker build -t strapi-app .",
      "docker stop $(docker ps -q) || true",
      "docker rm $(docker ps -aq) || true",
      "docker run -d -p 1337:1337 strapi-app"
    ]
  }
}

output "instance_public_ip" {
  value = aws_instance.arka_strapi.public_ip
}

output "instance_id" {
  value = aws_instance.arka_strapi.id
}

output "security_group_id" {
  value = aws_instance.arka_strapi.vpc_security_group_ids[0]
}
