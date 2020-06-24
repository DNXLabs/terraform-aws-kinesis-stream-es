resource "aws_cloudwatch_log_subscription_filter" "test_lambdafunction_logfilter" {
  name            = "es_lambdafunction_logfilter"
  role_arn        = aws_iam_role.cloudwatch_logs.arn
  log_group_name  = "/aws/lambda/LogGeneratorBrighteStream"
  filter_pattern  = ""
  destination_arn = aws_kinesis_firehose_delivery_stream.test_stream.arn
}
