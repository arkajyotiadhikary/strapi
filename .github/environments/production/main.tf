
resource "aws_instance" "arka_strapi" {
  ami                         = "ami-id"  # Update with your AMI ID
  availability_zone           = "ap-south-1a"  # Update with your availability zone
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["sg-123456"]  # Update with your security group ID
  subnet_id                   = "subnet-123456"  # Update with your subnet ID
  key_name                    = "strapipem"
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              {
                sudo apt update
                if ! command -v docker &> /dev/null; then
                  sudo apt install docker.io -y
                  sudo usermod -aG docker ubuntu
                  sudo chmod 660 /var/run/docker.sock
                fi
                echo ${var.docker_password} | docker login -u ${var.docker_username} --password-stdin
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
