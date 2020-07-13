resource "aws_lambda_function" "lambda_processor" {
  filename         = "${path.module}/${var.firehose_lambda_processor_name}.zip"
  function_name    = var.firehose_lambda_processor_name
  role             = aws_iam_role.lambda_iam.arn
  description      = "An Amazon Kinesis Firehose stream processor that extracts individual log events from records sent by Cloudwatch Logs subscription filters."
  handler          = "lambda_function.handler"
  runtime          = "python3.8"
  source_code_hash = data.archive_file.lambda_processor_zip.output_base64sha256
  timeout          = 180

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.firehose_lambda_delivery
  ]
}

resource "aws_iam_role" "lambda_iam" {
  name = "lambda_iam"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "firehose_lambda_delivery" {
  name              = "/aws/lambda/${var.firehose_lambda_processor_name}"
  retention_in_days = 14
}

resource "aws_iam_policy" "lambda_processor_logging" {
  name        = "lambda_processor_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "arn:aws:logs:*:*:*",
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_iam.name
  policy_arn = aws_iam_policy.lambda_processor_logging.arn
}