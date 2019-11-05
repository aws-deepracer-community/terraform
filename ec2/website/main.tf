variable "key_name" {}
variable "allow_http_id" {}
variable "allow_https_id" {}
variable "allow_ssh_id" {}
variable "allow_https_outbound_id" {}
variable "subnet_id" {}

resource "aws_instance" "website" {
  // Required
  ami = var.ami_id
  instance_type = "t2.micro"
  // Optional
  associate_public_ip_address = true
  key_name = var.key_name
  subnet_id = var.subnet_id
  tags = {
    Name = "WordPress",
    Terraform = "true"
  }
  vpc_security_group_ids = [ var.allow_http_id, var.allow_https_id, var.allow_ssh_id, var.allow_https_outbound_id ]
}

output "instance_id" {
  value = aws_instance.website.id
}
