locals {
  tags = merge(
    var.base_tags
  )

  image = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.container_image_name}:latest"
}