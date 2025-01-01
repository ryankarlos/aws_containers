
locals {
  repository_name    = var.repository_name
  dkr_img_src_path   = var.dkr_img_src_path
  ecr_repo           = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com"
  dkr_img_src_sha256 = sha256(join("", [for f in fileset(".", "${local.dkr_img_src_path}/**") : file(f)]))
}


locals {

  image_uri = "${aws_ecr_repository.app.name}/${var.repository_name}:${var.image_tag}"

}

locals {

  docker_commands = <<-EOT
        aws ecr get-login-password --region ${var.region} | docker login --username AWS \
        --password-stdin ${local.ecr_repo}

        docker build -t ${local.image_uri} \
        -f ${local.dkr_img_src_path}/Dockerfile .

        docker push ${local.image_uri}
    EOT

}



resource "aws_ecr_repository" "app" {
  image_tag_mutability = "MUTABLE"
  name                 = var.repository_name
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}


resource "null_resource" "docker_packaging" {

  depends_on = [
    aws_ecr_repository.app,
  ]
  provisioner "local-exec" {
    command = local.docker_commands
  }
  triggers = {
    detect_docker_source_changes = var.force_image_rebuild == true ? timestamp() : local.dkr_img_src_sha256
  }

}