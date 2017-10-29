
data "aws_route53_zone" "primary" {
  name = "${var.apex_domain}"
}

resource "aws_route53_record" "a" {
  zone_id = "${data.aws_route53_zone.primary.zone_id}"
  name    = "${var.site_domain}"
  type    = "A"

  alias {
    name    = "${aws_cloudfront_distribution.distribution.domain_name}"
    zone_id = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}
