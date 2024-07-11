# resource "aws_ecs_service" "strapi_service" {
#   name            = "strapi-service"
#   cluster         = aws_ecs_cluster.strapi_cluster.id
#   task_definition = aws_ecs_task_definition.ar-td.arn
#   desired_count   = 1
#   launch_type     = "FARGATE"

#   network_configuration {
#     subnets          = aws_subnet.public.*.id
#     security_groups  = [aws_security_group.alb_sg.id]
#     assign_public_ip = true
#   }

#   load_balancer {
#     target_group_arn = data.aws_lb_target_group.strapi_tg.arn
#     container_name   = "strapi"
#     container_port   = 1337
#   }
# }
resource "aws_ecs_service" "next-service" {
  name            = "next-service"
  cluster         = aws_ecs_cluster.strapi_cluster.id
  task_definition = aws_ecs_task_definition.ar_td.arn
  desired_count   = 1
  enable_ecs_managed_tags = true
  wait_for_steady_state = true

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
    
  }

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.alb_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.strapi_tg.arn
    container_name   = "my-next-app-container"
    container_port   = 1337
  }
}


# data "aws_network_interface" "interface_tags1" {
#   depends_on = [aws_ecs_service.next-service]
#   filter {
#     name   = "tag:aws:ecs:service-name"
#     values = [aws_ecs_service.next-service.name]
#   }
# }
