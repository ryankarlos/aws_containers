
variable "region" {
  description = "aws region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnets" {
  description = "Public subnet IDs"
  type        = list(string)
}


variable "security_groups" {
  type = list(string)
}


variable "repository_name" {
  description = "repo name"
  type        = string
}

variable "credentials" {
  type = object(
    {
      cert = string
      pk   = string
    }
  )
}


variable "dkr_img_src_path" {
  description = "path to dir containing dockerfile and app code"
  type        = string
}



variable "image_tag" {
  description = "image tag"
  type        = string
  default = "latest"
}



variable "force_image_rebuild" {
  type    = bool
}