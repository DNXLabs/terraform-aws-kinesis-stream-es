# resource "aws_kinesis_firehose_delivery_stream" "firehose_stream" {
#   name        = "kinesis-firehose-es-stream"
#   destination = "elasticsearch"

#   depends_on = [
#     aws_iam_role.firehose_role,
#     aws_elasticsearch_domain.es,
#   ]

#   s3_configuration {
#     role_arn           = aws_iam_role.firehose_role.arn
#     bucket_arn         = aws_s3_bucket.bucket.arn
#     buffer_size        = 10
#     buffer_interval    = 400
#     compression_format = "GZIP"

#     cloudwatch_logging_options {
#       enabled         = true
#       log_group_name  = aws_cloudwatch_log_group.kinesis_delivery.name
#       log_stream_name = aws_cloudwatch_log_stream.s3_delivery.name
#     }
#   }

#   elasticsearch_configuration {
#     domain_arn         = aws_elasticsearch_domain.es[0].arn
#     role_arn           = aws_iam_role.firehose_role.arn
#     index_name         = var.kinesis_firehose_index_name
#     buffering_interval = 60
#     retry_duration     = 60

#     vpc_config {
#       role_arn           = aws_iam_role.firehose_role.arn
#       security_group_ids = [aws_security_group.es_sec_grp.id]
#       subnet_ids         = var.private_subnet_ids
#     }

#     cloudwatch_logging_options {
#       enabled         = true
#       log_group_name  = aws_cloudwatch_log_group.kinesis_delivery.name
#       log_stream_name = aws_cloudwatch_log_stream.elasticsearch_delivery.name
#     }

#     processing_configuration {
#       enabled = "true"

#       processors {
#         type = "Lambda"

#         parameters {
#           parameter_name  = "LambdaArn"
#           parameter_value = "${aws_lambda_function.lambda_processor.arn}:$LATEST"
#         }
#       }
#     }
#   }
# }

# resource "aws_cloudwatch_log_group" "kinesis_delivery" {
#   name = "/aws/kinesisfirehose/kinesis-firehose-es-stream"
# }

# resource "aws_cloudwatch_log_stream" "elasticsearch_delivery" {
#   name           = "ElasticsearchDelivery"
#   log_group_name = aws_cloudwatch_log_group.kinesis_delivery.name
# }

# resource "aws_cloudwatch_log_stream" "s3_delivery" {
#   name           = "S3Delivery"
#   log_group_name = aws_cloudwatch_log_group.kinesis_delivery.name
# }
