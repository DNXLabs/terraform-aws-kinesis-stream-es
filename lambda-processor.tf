resource "aws_lambda_function" "lambda_processor" {
  filename      = "firehose_lambda_processor.zip"
  function_name = "firehose_lambda_processor"
  role          = aws_iam_role.lambda_iam.arn
  handler       = "index.handler"
  runtime       = "nodejs12.x"
  source_code_hash = data.archive_file.lambda_processor_zip.output_base64sha256
  timeout       = 60
}

resource "aws_iam_role" "lambda_iam" {
  name = "lambda_iam"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": "sts:AssumeRole",
        "Principal": {
            "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
        }
    ]
  })
}
