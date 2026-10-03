#ECR

resource "aws_ecr_repository" "site" {
  name                 = "site_prod"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}
