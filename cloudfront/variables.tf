variable "acl" {
  type        = string
  description = "The canned ACL to apply. We recommend log-delivery-write for compatibility with AWS services"
  default     = "log-delivery-write"
}

variable "aws_s3_bucket_logging" {
  type        = string
  description = "Folder to log CF metrics too."
  default     = "deepracing-cloudfront-logging"
}

