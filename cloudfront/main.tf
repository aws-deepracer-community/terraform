variable "aws_alb_dns_name" {}
variable "web_acm_certificate_arn" {}
variable "wiki_acm_certificate_arn" {}

resource "aws_s3_bucket" "logging" {
  bucket = var.aws_s3_bucket_logging
  acl    = var.acl

  tags = {
    Name = var.aws_s3_bucket_logging
    Terraform = "true"
  }
}

module "website" {
  source = "./website"

  bucket_domain_name = aws_s3_bucket.logging.bucket_domain_name
  aws_alb_dns_name = var.aws_alb_dns_name
  web_acm_certificate_arn = var.web_acm_certificate_arn
}

module "wiki" {
  source = "./wiki"

  bucket_domain_name = aws_s3_bucket.logging.bucket_domain_name
  aws_alb_dns_name = var.aws_alb_dns_name
  wiki_acm_certificate_arn = var.wiki_acm_certificate_arn
}
