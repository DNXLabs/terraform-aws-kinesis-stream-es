resource "aws_iam_role" "cloudwatch_logs" {
  count = var.kinesis_firehose_enabled ? 1 : 0

  name = "cloudwatch_logs_to_firehose"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "logs.${data.aws_region.current.name}.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : "",
      },
    ],
  })
}

resource "aws_iam_role_policy" "cloudwatch_logs" {
  count = var.kinesis_firehose_enabled ? 1 : 0

  role = aws_iam_role.cloudwatch_logs[0].name

  policy = jsonencode({
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["firehose:*"],
        # "Resource": [aws_kinesis_firehose_delivery_stream.firehose_stream.arn]
        "Resource" : ["arn:aws:firehose:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:deliverystream/${var.kinesis_firehose_name}"],
      },
    ],
  })

}