resource "aws_ecs_task_definition" "ar_td" {
  family                   = "ar-str"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = jsonencode([{
      "name": "my-next-app-container",
      "image": "533266978173.dkr.ecr.ap-south-1.amazonaws.com/strapi-next:latest",
      "memory": 512,
      "cpu": 256,
      "essential": true,
      "portMappings": [
        {
          "containerPort": 1337,
          "hostPort": 1337
        }
      ]
    }])
}

data "aws_ecs_task_definition" "ar_td" {
  task_definition = aws_ecs_task_definition.ar_td.family
  depends_on      = [aws_ecs_task_definition.ar_td]
}

