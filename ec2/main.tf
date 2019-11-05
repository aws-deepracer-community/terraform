variable "allow_http_id" {}
variable "allow_https_id" {}
variable "allow_ssh_id" {}
variable "allow_http_outbound_id" {}
variable "allow_https_outbound_id" {}
variable "subnet_1_id" {}
variable "subnet_2_id" {}
variable "web_cert" {}
variable "wiki_cert" {}
variable "vpc_id" {}

module "key_pairs" {
  source = "./key_pairs"
}

module "website" {
  source = "./website"

  allow_http_id = var.allow_http_id
  allow_https_id = var.allow_https_id
  allow_https_outbound_id = var.allow_https_outbound_id
  allow_ssh_id = var.allow_ssh_id
  key_name = module.key_pairs.key_name
  subnet_id = var.subnet_1_id
}

module "wiki" {
  source = "./wiki"

  allow_http_id = var.allow_http_id
  allow_https_id = var.allow_https_id
  allow_https_outbound_id = var.allow_https_outbound_id
  allow_ssh_id = var.allow_ssh_id
  key_name = module.key_pairs.key_name
  subnet_id = var.subnet_1_id
}

module "load_balancer" {
  source = "./load_balancer"

  allow_http_id = var.allow_http_id
  allow_https_id = var.allow_https_id
  allow_http_outbound_id = var.allow_http_outbound_id
  allow_https_outbound_id = var.allow_https_outbound_id
  subnet_1_id = var.subnet_1_id
  subnet_2_id = var.subnet_2_id
  blog_instance_id = module.website.instance_id
  wiki_instance_id = module.wiki.instance_id
  web_cert = var.web_cert
  wiki_cert = var.wiki_cert
  vpc_id = var.vpc_id
}

module "backup_website" {
  source = "./backup_website"

  instance_id = module.website.instance_id
}

// Output values
output "aws_alb_dns_name" {
  value = module.load_balancer.aws_alb_dns_name
}
