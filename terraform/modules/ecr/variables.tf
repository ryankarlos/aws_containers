variable "repository_name" {
  description = "repo name"
  type        = string
}

variable "image_tag" {
  description = "docker image tag"
  type        = string
}

variable "dkr_img_src_path" {
  description = "path to dir containing dockerfile and app code"
  type        = string
}


variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository"
  type        = bool
  default     = false
}

variable "region" {
  description = "aws region"
  type        = string
}

variable "force_image_rebuild" {
  type    = bool
  default = true
}