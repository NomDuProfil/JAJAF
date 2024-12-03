
resource "aws_cloudfront_function" "jajaf_ip_filtering_function" {
  name    = "Jajaf${var.project_name}"
  runtime = "cloudfront-js-2.0"
  comment = "CloudFront Function for IP filtering"

  code = templatefile("${path.module}/jajaf_cloudfront_function/jajaf_cloudfront_function.js.tpl", {
    jajaf_ip_whitelist = join(", ", formatlist("\"%s\"", var.ip_whitelist))
  })
}
