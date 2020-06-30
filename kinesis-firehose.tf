resource "aws_kinesis_firehose_delivery_stream" "test_stream" {
  name        = "terraform-kinesis-firehose-test-stream"
  destination = "elasticsearch"

  s3_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    bucket_arn         = aws_s3_bucket.bucket.arn
    buffer_size        = 10
    buffer_interval    = 400
    compression_format = "GZIP"

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.kinesis.name
      log_stream_name = aws_cloudwatch_log_stream.s3_delivery.name
    }
  }

  elasticsearch_configuration {
    domain_arn         = aws_elasticsearch_domain.es.arn
    role_arn           = aws_iam_role.firehose_role.arn
    index_name         = "kinesis"
    buffering_interval = 60
    retry_duration     = 60

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.kinesis.name
      log_stream_name = aws_cloudwatch_log_stream.elasticsearch_delivery.name
    }

    processing_configuration {
      enabled = "true"

      processors {
        type = "Lambda"

        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = "${aws_lambda_function.lambda_processor.arn}:$LATEST"
        }
      }
    }
  }
}

resource "aws_cloudwatch_log_group" "kinesis" {
  name = "/aws/kinesisfirehose/terraform-kinesis-firehose-test-stream"
}

resource "aws_cloudwatch_log_stream" "elasticsearch_delivery" {
  name           = "ElasticsearchDelivery"
  log_group_name = aws_cloudwatch_log_group.kinesis.name
}

resource "aws_cloudwatch_log_stream" "s3_delivery" {
  name           = "S3Delivery"
  log_group_name = aws_cloudwatch_log_group.kinesis.name
}
