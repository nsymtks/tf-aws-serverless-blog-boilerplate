
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "${var.site_domain}"
}

resource "aws_cloudfront_distribution" "distribution" {
  enabled = true
  comment = "${var.site_domain}"
  aliases = ["${var.site_domain}"]

  default_root_object = "index.html"

  origin {
    domain_name = "${aws_s3_bucket.s3_bucket.bucket_domain_name}"
    origin_id   = "s3-${var.site_domain}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET","HEAD"]
    cached_methods   = ["GET","HEAD"]
    target_origin_id = "s3-${var.site_domain}"

    compress = true

    min_ttl     = 0
    max_ttl     = 31536000
    default_ttl = 86400

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "${var.acm_certificate_arn}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }

  tags {
    Name   = "${var.site_domain}"
    Domain = "${var.site_domain}"
    Group  = "${var.apex_domain}"
  }
}

