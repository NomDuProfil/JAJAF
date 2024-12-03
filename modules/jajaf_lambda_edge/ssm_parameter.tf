resource "aws_ssm_parameter" "jajaf_ssm_allowed_ips" {
  name  = "/jajaf/${var.project_name}/allowed_ips"
  type  = "StringList"
  value = join(",", var.ip_whitelist)
}
