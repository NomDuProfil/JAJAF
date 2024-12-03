locals {
  jajaf_sanitized_bucket_name = replace(var.project_name, "/[^A-Za-z0-9-]/", "-")
}

resource "aws_s3_bucket" "jajaf_bucket" {
  bucket = "jajaf-${local.jajaf_sanitized_bucket_name}"
}

resource "aws_s3_bucket_public_access_block" "jajaf_bucket_public" {
  bucket = aws_s3_bucket.jajaf_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "jajaf_bucket_policy_allow_cloudfront" {
  statement {
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      "${aws_s3_bucket.jajaf_bucket.arn}",
      "${aws_s3_bucket.jajaf_bucket.arn}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.jajaf_cloudfront_s3_oia.iam_arn]
    }
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${aws_s3_bucket.jajaf_bucket.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "jajaf_bucket_policy" {
  bucket = aws_s3_bucket.jajaf_bucket.id
  policy = data.aws_iam_policy_document.jajaf_bucket_policy_allow_cloudfront.json
}
