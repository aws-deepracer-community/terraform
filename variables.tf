// AWS
variable "region" {
  default = "eu-west-1"
}

// IAM Module
variable "support_iam_role_principal_arn" {
  default = ""
}
variable "aws_account_id" {
  default = ""
}

// CloudFront
variable "web_acm_certificate_arn" {
  default = ""
  description = "SSL Certificate ARN"
}
variable "wiki_acm_certificate_arn" {
  default = ""
  description = "SSL Certificate ARN"
}

// EC2 Module
variable "web_cert" {
  description = "Website certificate ACM ARN"
  default = ""
}
variable "wiki_cert" {
  description = "Wiki certificate ACM ARN"
  default = ""
}
