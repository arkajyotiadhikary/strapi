output "instance_public_ip" {
  value = aws_instance.ar_strapi_docker.public_ip
}

output "instance_id" {
  value = aws_instance.ar_strapi_docker.id
}
