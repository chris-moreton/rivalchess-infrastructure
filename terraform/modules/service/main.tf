resource "aws_ecs_service" "rivalchess_service" {
  name            = "rivalchess-${var.service_name}-service"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.rivalchess_task.arn
  launch_type     = "FARGATE"
  desired_count   = var.desired_task_count
  force_new_deployment = true

  network_configuration {
    subnets          = var.public_subnet_ids
    assign_public_ip = true
  }
}

resource "aws_ecs_task_definition" "rivalchess_task" {
  family                   = "rivalchess-${var.service_name}-task"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "rivalchess-${var.service_name}-task",
      "image": "${aws_ecr_repository.rivalchess_container_repository.repository_url}",
      "essential": true,
      "environment": [
        {
              "name": "ACTIVE_MQ_URL",
              "value": "${var.active_mq_url}"
        },
        {
              "name": "ACTIVE_MQ_USER",
              "value": "${var.active_mq_user}"
        },
        {
              "name": "ACTIVE_MQ_PASSWORD",
              "value": "${var.active_mq_password}"
        },
        {
              "name": "AWS_ACCESS_KEY_ID",
              "value": "${var.aws_access_key}"
        },
        {
              "name": "AWS_SECRET_ACCESS_KEY",
              "value": "${var.aws_secret_key}"
        },
        {
              "name": "S3_ENDPOINT",
              "value": "s3-eu-west-2.amazonaws.com"
        },
        {
              "name": "RIVALCHESS_DATASOURCE_URL",
              "value": "${var.db_url}"
        },
        {
              "name": "RIVALCHESS_DATASOURCE_USER",
              "value": "${var.db_user}"
        },
        {
              "name": "RIVALCHESS_DATASOURCE_PASSWORD",
              "value": "${var.db_password}"
        },
        {
              "name": "REDIS_URL",
              "value": "${var.redis_url}"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${var.log_group}",
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
  memory                   = var.container_memory
  cpu                      = var.container_cpu
  execution_role_arn       = var.task_execution_role
}

