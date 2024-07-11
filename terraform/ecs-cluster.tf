resource "aws_ecs_cluster" "strapi_cluster" {
  name = var.project_name
}
