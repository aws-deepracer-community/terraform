variable "aws_s3_bucket_logging_prefix" {
  type        = string
  description = "Prefix to use when logging CF metrics."
  default     = "website"
}

variable "cnames" {
  description = "CNAME records which you would later add the cloudfront DNS name to it"
  type        = "list"
  default = [ "blog.deepracing.io" ]
}

variable "cookies_whitelisted_names" {
  description = "List of cookies to be whitelisted."
  type        = "list"

  default = [
    "comment_author_*",
    "comment_author_email_*",
    "comment_author_url_*",
    "wordpress_*",
    "wordpress_logged_in_*",
    "wordpress_test_cookie",
    "wp-settings-*",
  ]
}

variable "default_ttl" {
  description = "The default amount of time an object is ina CloudFront cache before it sends another request in absence of Cache-Control"
  default     = 300
}

variable "domain_name" {
  description = "The domain of your origin. This is usually the root domain example.com "
  default     = "blog.deepracing.io"
}

variable "enabled" {
  description = "Set the status of the distribution"
  default     = true
}

variable "headers" {
  description = "Headers to forward from Cloudfront to the origin"
  type        = "list"
  default     = ["Host", "Origin"]
}

variable "http_port" {
  description = "The HTTP port which Cloudfront should connect to the origin"
  default     = 80
}

variable "https_port" {
  description = "The HTTPS port which the "
  default     = 443
}

variable "origin_id" {
  description = "Unique identifier of the origin"
  default = "ALB-blog.deepracing.io"
}

variable "origin_protocol_policy" {
  description = "Either one of them (http-only, https-only,match-viewer) "
  default     = "http-only"
}

variable "origin_ssl_protocols" {
  description = "The SSL/TLS protocols that you want CloudFront to use when communicating with your origin over HTTPS. A list of one or more  of SSLv3, TLSv1, TLSv1.1, and TLSv1.2."
  default     = ["TLSv1", "TLSv1.1"]
  type        = "list"
}

variable "min_ttl" {
  description = "The minimum time you want objects to stay in CloudFront"
  default     = 0
}

variable "max_ttl" {
  description = "The maxium amount of seconds you want CloudFront to cache the object, before feching it from the origin"
  default     = 31536000
}

variable "minimum_protocol_version" {
  description = "The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections."
  default     = "TLSv1"
  type        = "string"
}

variable "tags" {
  description = "Tags to identify the Cloudfront distribution"
  type        = "map"
  default     = {
    Environment = "production"
    Terraform = "true"
  }
}
