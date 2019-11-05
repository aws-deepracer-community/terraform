// Create IAM resources
module "iam" {
  source = "./iam"

  support_iam_role_principal_arn = var.support_iam_role_principal_arn
  aws_account_id = var.aws_account_id
}

// Create VPC resources
module "vpc" {
  source = "./vpc"

  vpc_flow_logs_iam_role_arn = module.iam.vpc_flow_logs_iam_role_arn
  aws_account_id = module.iam.aws_account_id
}

// Create EC2 resources
module "ec2" {
  source = "./ec2"

  allow_http_id = module.vpc.allow_http_id
  allow_https_id = module.vpc.allow_https_id
  allow_http_outbound_id = module.vpc.allow_http_outbound_id
  allow_https_outbound_id = module.vpc.allow_https_outbound_id
  allow_ssh_id = module.vpc.allow_ssh_id
  subnet_1_id = module.vpc.subnet_1
  subnet_2_id = module.vpc.subnet_2
  web_cert = var.web_cert
  wiki_cert = var.wiki_cert
  vpc_id = module.vpc.vpc_id
}

// Create CloudFront resources
module "cloudfront" {
  source = "./cloudfront"

  aws_alb_dns_name = module.ec2.aws_alb_dns_name
  web_acm_certificate_arn = var.web_acm_certificate_arn
  wiki_acm_certificate_arn = var.wiki_acm_certificate_arn
}
