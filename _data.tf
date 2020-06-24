data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "archive_file" "lambda_processor_zip" {
    type          = "zip"
    source_file   = "firehose_lambda_processor/lambda_function.py"
    output_path   = "firehose_lambda_processor.zip"
}