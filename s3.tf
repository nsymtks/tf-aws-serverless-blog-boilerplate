
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.site_domain}"
  acl    = "private"

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

  tags {
    Name   = "${var.site_domain}"
    Domain = "${var.site_domain}"
    Group  = "${var.apex_domain}"
  }
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = "${aws_s3_bucket.s3_bucket.id}"
  policy = "${data.aws_iam_policy_document.s3_policy.json}"
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    sid       = "PublicReadForGetBucketObjects"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.s3_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }
}

