variable "wiki_acm_certificate_arn" {}
variable "aws_alb_dns_name" {}
variable "bucket_domain_name" {}

resource "aws_cloudfront_distribution" "wiki_cdn" {
  aliases = "${var.cnames}"
  enabled = "${var.enabled}"
  tags    = "${var.tags}"

  origin {
    domain_name = "${var.aws_alb_dns_name}"
    origin_id   = "${var.origin_id}"

    custom_origin_config {
      http_port              = "${var.http_port}"
      https_port             = "${var.https_port}"
      origin_protocol_policy = "${var.origin_protocol_policy}"
      origin_ssl_protocols   = "${var.origin_ssl_protocols}"
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = var.wiki_acm_certificate_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "${var.minimum_protocol_version}"
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.origin_id}"

    forwarded_values {
      query_string = true
      headers      = ["Host", "Origin"]

      cookies {
        forward           = "whitelist"
        whitelisted_names = "${var.cookies_whitelisted_names}"
      }
    }

    compress               = true
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = "${var.min_ttl}"
    default_ttl            = "${var.default_ttl}"
    max_ttl                = "${var.max_ttl}"
  }

  ordered_cache_behavior {
    path_pattern     = "Special*"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "${var.origin_id}"

    forwarded_values {
      query_string = true
      headers      = var.headers

      cookies {
        forward           = "all"
      }
    }

    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    path_pattern     = "index.php"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "${var.origin_id}"

    forwarded_values {
      query_string = true
      headers      = var.headers

      cookies {
        forward           = "all"
      }
    }

    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  logging_config {
    include_cookies = false
    bucket          = var.bucket_domain_name
    prefix          = var.aws_s3_bucket_logging_prefix
  }
}
