output "kinesis_arn" {
  value = "arn:aws:firehose:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:deliverystream/${var.kinesis_firehose_name}"
}