variable "acl" {
  type        = string
  description = "The canned ACL to apply. We recommend log-delivery-write for compatibility with AWS services"
  default     = "private"
}

variable "aws_s3_bucket_alb_logging" {
  type        = string
  description = "Folder to log CF metrics too."
  default     = "deepracing-alb-logging"
}
