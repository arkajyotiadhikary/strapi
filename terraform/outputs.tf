# output "instance_id" {
#   value = aws_instance.ar-strapi.id
# }

# output "public_ip" {
#   value = aws_instance.ar-strapi.public_ip
# }

output "subdomain_dns_name" {
  value = "arka.${var.domain_name}"
}
