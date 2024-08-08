
resource "aws_appconfig_extension" "this" {
  name        = var.extension_name
  description = "Write configuration profiles to S3 as they are deployed"
  action_point {
    point = "PRE_START_DEPLOYMENT"
    action {
      name     = "PreStartDeploymentActionForS3Backup"
      role_arn = aws_iam_role.extension.arn
      uri      = aws_lambda_function.this.arn
    }
  }
  parameter {
    name        = "S3_BUCKET"
    required    = true
    description = "bucket name for backup"
  }
}

resource "aws_iam_role" "extension" {
  name = "app-config-backup-extension-role-${random_id.this.hex}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "appconfig.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "extension" {
  name = "app-config-backup-extension-policy-${random_id.this.hex}"
  role = aws_iam_role.extension.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "InvokeLambda"
      Effect = "Allow"
      Action = [
        "lambda:InvokeFunction",
        "lambda:InvokeAsync",
      ]
      Resource = aws_lambda_function.this.arn
    }]
  })
}

resource "aws_lambda_function" "this" {
  filename         = "lambda_function_payload.zip"
  function_name    = var.lambda_function_name
  source_code_hash = data.archive_file.code.output_base64sha256
  handler          = "index.handler"

  role = aws_iam_role.lambda.arn

  architectures = ["arm64"]
  runtime       = "nodejs20.x"
  publish       = false

  logging_config {
    log_format = "Text"
    log_group  = aws_cloudwatch_log_group.this.id
  }
}

data "archive_file" "code" {
  type        = "zip"
  source_file = "${path.module}/index.mjs"
  output_path = "lambda_function_payload.zip"
}

resource "aws_iam_role" "lambda" {
  name = "${var.lambda_function_name}-role-${random_id.this.hex}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "lambda" {
  name = "${var.lambda_function_name}-role-policy-${random_id.this.hex}"
  role = aws_iam_role.lambda.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "createStreamAndPutEvents"
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ],
        Resource = [
          aws_cloudwatch_log_group.this.arn,
          "${aws_cloudwatch_log_group.this.arn}:*",
        ]
      },
      {
        Sid      = "allowPutObject"
        Effect   = "Allow"
        Action   = "s3:PutObject"
        Resource = "arn:aws:s3:::${var.s3_bucket_name}/*"
      },
    ]
  })
}

resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/lambda/${var.lambda_function_name}"

  retention_in_days = var.log_retention_in_days
}

resource "aws_s3_bucket" "backup" {
  count = var.create_s3_bucket ? 1 : 0

  bucket = var.s3_bucket_name
}

resource "random_id" "this" {
  byte_length = 4
}
