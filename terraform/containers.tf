resource "aws_ecr_repository" "rivalchess_player" {
  name                 = "rivalchess-vie-player"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "rivalchess_recorder" {
  name                 = "rivalchess-vie-recorder"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "rivalchess_generator" {
  name                 = "rivalchess-vie-generator"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
