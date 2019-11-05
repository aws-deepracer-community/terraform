resource "tls_private_key" "eu-west-1-2019" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "${var.key_name}"
  public_key = "${tls_private_key.eu-west-1-2019.public_key_openssh}"
}

output "key_name" {
  value = aws_key_pair.generated_key.key_name
}
