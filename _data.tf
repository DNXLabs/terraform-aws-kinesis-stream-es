data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "archive_file" "lambda_processor_zip" {
    type          = "zip"
    source_file   = "index.js"
    output_path   = "firehose_lambda_processor.zip"
}