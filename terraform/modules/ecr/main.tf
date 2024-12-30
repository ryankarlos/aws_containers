
resource "aws_ecr_repository" "app" {
  image_tag_mutability = "MUTABLE"
  name                 = "fast_api_ecs"
  encryption_configuration {
    encryption_type = "AES256"
  }
  image_scanning_configuration {
    scan_on_push = false
  }
}
