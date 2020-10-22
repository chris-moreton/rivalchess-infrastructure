resource "aws_ecs_service" "rivalchess_service" {
  name            = "rivalchess-${var.service_name}-service"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.rivalchess_task.arn
  launch_type     = "FARGATE"
  desired_count   = var.desired_task_count
  force_new_deployment = true

  load_balancer {
    target_group_arn = aws_lb_target_group.rivalchess_targets.arn
    container_name   = aws_ecs_task_definition.rivalchess_task.family
    container_port   = var.container_port
  }

  network_configuration {
    subnets          = var.public_subnet_ids
    assign_public_ip = true
    security_groups  = [aws_security_group.rivalchess_service_security_group.id]
  }

  depends_on = [aws_lb_target_group.rivalchess_targets]
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
      "portMappings": [
        {
          "containerPort": ${var.container_port},
          "hostPort": ${var.container_port}
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

resource "aws_security_group" "rivalchess_service_security_group" {

  name = "rivalchess-${var.service_name}-service-sg"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    # Only allowing traffic in from the load balancer security group
    security_groups = [aws_security_group.rivalchess_lb_security_group.id]
  }

  egress {
    from_port   = 0 # Allowing any incoming port
    to_port     = 0 # Allowing any outgoing port
    protocol    = "-1" # Allowing any outgoing protocol
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }
}

resource "aws_alb" "rivalchess_lb" {
  name               = "rivalchess-${var.service_name}-lb"
  load_balancer_type = "application"
  subnets          = var.public_subnet_ids
  security_groups = [aws_security_group.rivalchess_lb_security_group.id]

  access_logs {
    bucket = "bubblloadbalancerlogs"
    prefix = "bubbl-"
  }
}

resource "aws_security_group" "rivalchess_lb_security_group" {

  name = "rivalchess-${var.service_name}-lb-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "rivalchess_targets" {
  vpc_id = var.vpc_id

  name        = "rivalchess-${var.service_name}-targets"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"

  health_check {
    interval = 300
    matcher = "200"
    path = "/"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_alb.rivalchess_lb]
}

resource "aws_lb_listener" "rivalchess_listener" {
  load_balancer_arn = aws_alb.rivalchess_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rivalchess_targets.arn
  }
}

