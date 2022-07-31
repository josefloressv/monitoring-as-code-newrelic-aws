resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
 
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_ecs_task_definition" "base" {
  family                   = var.task_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = local.image
      cpu       = var.container_cpu
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
          hostPort      = var.container_port
        }
      ]
    }
  ])

  runtime_platform {
    operating_system_family = var.task_os_family
    cpu_architecture        = var.task_cpu_architecture
  }

  tags = merge(
    local.tags,
    var.task_tags
  )
}

resource "aws_lb_target_group" "tg-app" {
  name        = var.tg_name
  target_type = "ip"
  vpc_id      = var.aws_vpc_id
  port        = var.tg_port
  protocol    = "HTTP"
  health_check {
    path                = var.tg_health_check_path
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200,301,302"
  }

  tags = merge(
    local.tags,
    var.tg_tags
  )
}

data "aws_lb" "selected" {
  name = var.tg_alb_name
}

data "aws_lb_listener" "selected80" {
  load_balancer_arn = data.aws_lb.selected.arn
  port              = var.tg_port
}

resource "aws_lb_listener_rule" "lr-rule" {
  listener_arn = data.aws_lb_listener.selected80.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-app.arn
  }

  condition {
    path_pattern {
      values = [var.listener_context_path]
    }
  }
}

data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [var.aws_vpc_id]
  }
}

resource "aws_ecs_service" "service" {
  name            = var.service_name
  cluster         = var.cluster_name
  task_definition = aws_ecs_task_definition.base.arn
  desired_count   = var.service_desired_count

  load_balancer {
    target_group_arn = aws_lb_target_group.tg-app.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  # Optional: Allow external changes without Terraform plan difference(for example ASG)
  lifecycle {
    ignore_changes = [desired_count]
  }

  launch_type = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.all.ids
    security_groups  = var.service_sg_ids
    assign_public_ip = true
  }

}

resource "aws_ecr_repository" "ecr-app" {
  name                 = var.ecr_repo_name
  image_tag_mutability = var.ecr_repo_tag_mutability
  tags = merge(
    local.tags,
    var.ecr_repo_tags
  )
}

resource "aws_ecr_lifecycle_policy" "ecr-app-policy" {
  repository = aws_ecr_repository.ecr-app.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "${var.ecr_repo_policy_description}",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": ${var.ecr_repo_policy_expiration_days}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
