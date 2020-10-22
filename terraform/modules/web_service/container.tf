resource "aws_ecr_repository" "rivalchess_container_repository" {
  name                 = "rivalchess-vie-${var.service_name}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
