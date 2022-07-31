resource "aws_ecs_cluster" "fargate-cluster" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(
    local.tags,
    var.cluster_tags
  )
}

resource "aws_ecs_cluster_capacity_providers" "fargate-default-capacity-provider" {
  cluster_name = aws_ecs_cluster.fargate-cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}
