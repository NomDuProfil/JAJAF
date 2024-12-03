data "aws_cloudfront_cache_policy" "jajaf_cache_policy" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_origin_access_identity" "jajaf_cloudfront_s3_oia" {
  comment = "Jajaf origin for s3 bucket jajaf-${local.jajaf_sanitized_bucket_name}"
}

resource "aws_cloudfront_distribution" "jajaf_s3_distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  http_version        = "http2and3"
  price_class         = "PriceClass_100"

  origin {
    domain_name = aws_s3_bucket.jajaf_bucket.bucket_regional_domain_name
    origin_id   = "S3-jajaf-${local.jajaf_sanitized_bucket_name}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.jajaf_cloudfront_s3_oia.cloudfront_access_identity_path
    }
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-jajaf-${local.jajaf_sanitized_bucket_name}"
    cache_policy_id        = data.aws_cloudfront_cache_policy.jajaf_cache_policy.id
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.jajaf_ip_filtering_function.arn
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }

}
