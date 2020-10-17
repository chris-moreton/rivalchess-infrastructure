resource "aws_ecs_service" "rivalchess_player_service" {
  name            = "rivalchess-rivalchess-player-service"
  cluster         = aws_ecs_cluster.rivalchess_ecs_cluster.id
  task_definition = aws_ecs_task_definition.rivalchess_player_task.arn
  launch_type     = "FARGATE"
  desired_count   = 3
  force_new_deployment = true

  network_configuration {
    subnets          = [aws_default_subnet.default.id]
    assign_public_ip = false
  }
}

resource "aws_ecs_task_definition" "rivalchess_player_task" {
  family                   = "rivalchess-rivalchess-player-task"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "rivalchess-rivalchess-player-task",
      "image": "${aws_ecr_repository.rivalchess_player.repository_url}",
      "essential": true,
      "environment": [
        {
              "name": "ACTIVE_MQ_URL",
              "value": "${aws_mq_broker.rivalchess_activemq.instances.0.endpoints.0}"
        },
        {
              "name": "ACTIVE_MQ_USER",
              "value": "${var.active_mq_user}"
        },
        {
              "name": "ACTIVE_MQ_PWD",
              "value": "${var.active_mq_password}"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.rivalchess.name}",
          "awslogs-region": "${var.aws_vpc_region}",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 512
  cpu                      = 256
  execution_role_arn       = aws_iam_role.rivalchessEcsTaskExecutionRole.arn
}
