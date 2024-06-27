# modules/ec2/main.tf
resource "aws_instance" "arka_strapi" {
  ami                         = var.ami_id
  availability_zone           = var.availability_zone
  instance_type               = var.instance_type
  vpc_security_group_ids      = [var.security_group_id]
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  associate_public_ip_address = true

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
      private_key = file(var.private_key_path)
      host        = aws_instance.ec2forstrapi.public_ip
    }
    inline = [
      "sudo apt update",
      "export DEBIAN_FRONTEND=noninteractive",
      "if ! command -v docker &> /dev/null; then sudo apt install docker.io -y && sudo usermod -aG docker ubuntu && sudo chmod 660 /var/run/docker.sock; fi",
      "git clone https://github.com/arkajyotiadhikary/strapi.git -b arka-prod",
      "cd strapi",
      "docker build -t strapi-app .",
      "docker stop $(docker ps -q) || true",
      "docker rm $(docker ps -aq) || true",
      "docker run -d -p 1337:1337 strapi-app"
    ]
  }
}
