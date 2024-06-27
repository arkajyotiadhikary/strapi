resource "aws_instance" "ar_strapi_docker" {
  ami           = "ami-0f58b397bc5c1f2e8"
  instance_type = "t2.medium"
  subnet_id     = data.aws_subnet.first.id
  vpc_security_group_ids = [aws_security_group.strapi_sg.id]
  key_name = "ps_pd_a"

  user_data = file("user_data.sh")

  tags = {
    Name = "ar-strapi-docker"
  }
}
