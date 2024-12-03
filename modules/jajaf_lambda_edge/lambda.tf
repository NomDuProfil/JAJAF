resource "local_file" "jajaf_local_lambda_python" {
  filename = "./code_output/${var.project_name}/jajaf_lambda/jajaf_lambda.py"
  content = templatefile("${path.module}/jajaf_lambda/jajaf_lambda.py.tpl", {
    jajaf_ssm_name = "/jajaf/${var.project_name}/allowed_ips"
  })
}

data "archive_file" "jajaf_lambda_zip_dir" {
  type        = "zip"
  output_path = "./zip_output/${var.project_name}/jajaf_lambda.zip"
  source_dir  = "./code_output/${var.project_name}/jajaf_lambda"

  depends_on = [local_file.jajaf_local_lambda_python]
}

resource "aws_lambda_function" "jajaf_lambda_edge" {
  filename         = data.archive_file.jajaf_lambda_zip_dir.output_path
  function_name    = "jajaf_${var.project_name}_lambda"
  role             = aws_iam_role.jajaf_lambda_edge_role.arn
  handler          = "jajaf_lambda.lambda_handler"
  runtime          = "python3.13"
  source_code_hash = data.archive_file.jajaf_lambda_zip_dir.output_base64sha256
  publish          = true

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_iam_role_policy_attachment.jajaf_lambda_edge_policy]
}
