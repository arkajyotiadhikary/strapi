output "instance_public_ip" {
  value = module.ec2.instance_public_ip
}

output "instance_id" {
  value = module.ec2.instance_id
}

output "security_group_id" {
  value = aws_security_group.strapi_sg.id
}