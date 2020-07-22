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

  role = aws_iam_role.cloudwatch_logs[count.index].name

  policy = jsonencode({
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["firehose:*"],
        # "Resource": [aws_kinesis_firehose_delivery_stream.firehose_stream.arn]
        "Resource" : [var.kinesis_firehose_arn],
      },
    ],
  })
}