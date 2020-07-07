data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "archive_file" "lambda_processor_zip" {
  type        = "zip"
  source_file = "${path.module}/${var.firehose_lambda_processor_name}/lambda_function.py"
  output_path = "${path.module}/${var.firehose_lambda_processor_name}.zip"
}
