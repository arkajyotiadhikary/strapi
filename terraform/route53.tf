resource "aws_route53_record" "subdomain_record" {
  zone_id = var.hosted_zone_id
  name    = "${var.sub_domain}."
  type    = "A"
  alias {
    name                   = aws_lb.strapi_lb.dns_name
    zone_id                = aws_lb.strapi_lb.zone_id
    evaluate_target_health = false
  }
}
