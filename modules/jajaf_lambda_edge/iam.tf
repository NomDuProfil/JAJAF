resource "aws_iam_role" "jajaf_lambda_edge_role" {
  name = "jajaf_${var.project_name}_lambda_edge_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = [
            "lambda.amazonaws.com",
            "edgelambda.amazonaws.com"
          ]
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jajaf_lambda_edge_policy" {
  role       = aws_iam_role.jajaf_lambda_edge_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "jajaf_ssm_access" {
  name = "jajaf_${var.project_name}_ssm_access_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["ssm:GetParameter"],
        Effect   = "Allow",
        Resource = aws_ssm_parameter.jajaf_ssm_allowed_ips.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jajaf_attach_ssm_policy" {
  role       = aws_iam_role.jajaf_lambda_edge_role.name
  policy_arn = aws_iam_policy.jajaf_ssm_access.arn
}
