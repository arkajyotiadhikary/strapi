output "instance_public_ip" {
  value = aws_instance.arka_strapi.public_ip
}

output "instance_id" {
  value = aws_instance.arka_strapi.id
}
