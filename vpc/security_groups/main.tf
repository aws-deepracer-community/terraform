variable "vpc_id" {}

resource "aws_security_group" "allow_https" {
  // Optional
  name        = "allow_https"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    // Required
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    // Optional
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "allow_https"
  }
}

resource "aws_security_group" "allow_http" {
  // Optional
  name        = "allow_http"
  description = "Allow http inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    // Required
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    // Optional
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "allow_http"
  }
}

resource "aws_security_group" "allow_ssh" {
  // Optional
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    // Required
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    // Optional
    cidr_blocks = [ "197.89.156.59/32", "77.102.114.125/32" ]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_security_group" "allow_https_outbound" {
  // Optional
  name        = "allow_https_outbound"
  description = "Allow TLS outbound traffic"
  vpc_id      = var.vpc_id

  egress {
    // Required
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    // Optional
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "allow_https_outbound"
  }
}

resource "aws_security_group" "allow_http_outbound" {
  // Optional
  name        = "allow_http_outbound"
  description = "Allow http outbound traffic"
  vpc_id      = var.vpc_id

  egress {
    // Required
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    // Optional
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "allow_http_outbound"
  }
}

output "allow_http_id" {
  value = aws_security_group.allow_http.id
}

output "allow_https_id" {
  value = aws_security_group.allow_https.id
}

output "allow_ssh_id" {
  value = aws_security_group.allow_ssh.id
}

output "allow_http_outbound_id" {
  value = aws_security_group.allow_http_outbound.id
}

output "allow_https_outbound_id" {
  value = aws_security_group.allow_https_outbound.id
}
