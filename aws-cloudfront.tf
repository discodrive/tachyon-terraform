resource "aws_cloudfront_distribution" "s3_proxy" {
  origin {
    domain_name = aws_s3_bucket.assets.bucket_regional_domain_name
    origin_id   = "S3-Proxy"

    # This uses the pre-created Origin Access Identity to allow CloudFront to access the target S3 bucket
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = aws_api_gateway_deployment.tachyon-api-deployment.invoke_url
    origin_id   = "Substrakt-Tachyon-Image-Resizer-Stack"
    origin_path = "/Prod"

    custom_origin_config {
      origin_protocol_policy   = "https-only"
      origin_ssl_protocols     = ["SSLv3"]
      origin_keepalive_timeout = 5
      http_port                = 80
      https_port               = 443
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  comment             = "S3 proxy for use with Tachyon"

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.logs.bucket_domain_name
    prefix          = ""
  }

  aliases = ["images.${var.domain_name}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "Substrakt-Tachyon-Image-Resizer-Stack"

    forwarded_values {
      query_string = true
      headers      = ["X-WebP"]
      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 63115201
    max_ttl                = 63115202
    compress               = false
    viewer_protocol_policy = "allow-all"
  }

  ordered_cache_behavior {
    path_pattern     = "*.gif"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-Proxy"

    forwarded_values {
      query_string = true
      headers      = ["Origin", "Access-Control-Request-Headers", "Access-Control-Request-Method"]
      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 63115201
    max_ttl                = 63115202
    compress               = false
    viewer_protocol_policy = "allow-all"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert.arn
  }
}
