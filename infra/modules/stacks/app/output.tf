output "aws_ecr_repository_url" {
  value = "http://${aws_ecr_repository.ecr-app.repository_url}"
}
