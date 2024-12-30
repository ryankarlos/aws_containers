
variable "s3_bucket_arn" {
  description = "S3 bucket ARN for task role access"
  type        = string
  default     = ""
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}


variable "project" {
  description = "Project"
  type        = string
}

variable "tags" {
  description = "tag"
  type        = string
}