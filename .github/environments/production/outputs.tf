output "instance_public_ip" {
  value = aws_instance.arka_strapi.public_ip
}

output "instance_id" {
  value = aws_instance.arka_strapi.id
}

output "security_group_id" {
  value = aws_instance.arka_strapi.vpc_security_group_ids[0]
}
