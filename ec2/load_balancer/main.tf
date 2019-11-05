// Input values
variable "allow_http_id" {}
variable "allow_https_id" {}
variable "allow_http_outbound_id" {}
variable "allow_https_outbound_id" {}
variable "subnet_1_id" {}
variable "subnet_2_id" {}
variable "blog_instance_id" {}
variable "wiki_instance_id" {}
variable "web_cert" {}
variable "wiki_cert" {}
variable "vpc_id" {}

// Create bucket for alb logging
resource "aws_s3_bucket" "alb_logging" {
  bucket = var.aws_s3_bucket_alb_logging
  acl    = var.acl

  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.aws_s3_bucket_alb_logging}/*",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.default.arn}"
        ]
      }
    }
  ]
}
POLICY

  tags = {
    Name = var.aws_s3_bucket_alb_logging
    Terraform = "true"
  }
}

# https://www.terraform.io/docs/providers/aws/d/elb_service_account.html
data "aws_elb_service_account" "default" {}

// Create ALB
resource "aws_alb" "alb" {
  name               = "Web-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [ var.allow_http_id, var.allow_https_id, var.allow_http_outbound_id, var.allow_https_outbound_id ]
  subnets            = [ var.subnet_1_id, var.subnet_2_id ]

  enable_deletion_protection = true

  access_logs {
    bucket  = "${aws_s3_bucket.alb_logging.bucket}"
    prefix  = "Web-ALB"
    enabled = true
  }

  tags = {
    Name = "Web-ALB",
    Terraform = "true"
  }
}

// Create Listener
resource "aws_alb_listener" "web_ssl_listener" {
  default_action {
    target_group_arn = aws_alb_target_group.web_ssl_target.arn
    type = "forward"
  }
  load_balancer_arn = aws_alb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.web_cert

  depends_on = [ aws_alb.alb, aws_alb_target_group.web_ssl_target ]
}

// Add SSL Certs
resource "aws_lb_listener_certificate" "web_ssl_cert" {
  listener_arn    = "${aws_alb_listener.web_ssl_listener.arn}"
  certificate_arn = var.web_cert

  depends_on = [ aws_alb_listener.web_ssl_listener ]
}

resource "aws_lb_listener_certificate" "wiki_ssl_cert" {
  listener_arn    = "${aws_alb_listener.web_ssl_listener.arn}"
  certificate_arn = var.wiki_cert

  depends_on = [ aws_alb_listener.web_ssl_listener ]
}

// Create target group
resource "aws_alb_target_group" "web_ssl_target" {
  name      = "WebSSL"
  port      = 443
  protocol  = "HTTPS"
  vpc_id    = var.vpc_id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    path                = "/"
    interval            = 10
    port                = 80
    matcher             = "200"
  }

  stickiness {
    type = "lb_cookie"
    enabled = true
  }
}

resource "aws_alb_target_group" "wiki_ssl_target" {
  name      = "WikiSSL"
  port      = 443
  protocol  = "HTTPS"
  vpc_id    = var.vpc_id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    path                = "/"
    interval            = 10
    port                = 80
    matcher             = "200,301"
  }

  stickiness {
    type = "lb_cookie"
    enabled = true
  }
}

// Attach instances to target group
resource "aws_alb_target_group_attachment" "web_ssl" {
  target_group_arn = aws_alb_target_group.web_ssl_target.arn
  target_id = var.blog_instance_id
  port = 443

  depends_on = [ aws_alb_target_group.web_ssl_target ]
}

resource "aws_alb_target_group_attachment" "wiki_ssl" {
  target_group_arn = aws_alb_target_group.wiki_ssl_target.arn
  target_id = var.wiki_instance_id
  port = 443

  depends_on = [ aws_alb_target_group.wiki_ssl_target ]
}

// Create alb listener rules
resource "aws_lb_listener_rule" "website_rule" {
  listener_arn = "${aws_alb_listener.web_ssl_listener.arn}"
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.web_ssl_target.arn}"
  }

  condition {
    field  = "host-header"
    values = [ "blog.deepracing.io" ]
  }

  depends_on = [ aws_alb_listener.web_ssl_listener, aws_alb_target_group.web_ssl_target ]
}

resource "aws_lb_listener_rule" "wiki_rule" {
  listener_arn = "${aws_alb_listener.web_ssl_listener.arn}"
  priority     = 3

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.wiki_ssl_target.arn}"
  }

  condition {
    field  = "host-header"
    values = [ "wiki.deepracing.io" ]
  }

  depends_on = [ aws_alb_listener.web_ssl_listener, aws_alb_target_group.wiki_ssl_target ]
}

// Output values
output "aws_alb_dns_name" {
  value = aws_alb.alb.dns_name
}

