resource "aws_iam_role" "firehose_role" {
  count = var.elasticsearch_enabled ? 1 : 0

  name = "firehose_es_stream_role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "firehose.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_role_policy" "firehose_role" {
  count = var.elasticsearch_enabled ? 1 : 0

  role = aws_iam_role.firehose_role[0].name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObjectAcl",
          "s3:PutObject"
        ],
        "Resource" : [
          "${aws_s3_bucket.bucket.arn}",
          "${aws_s3_bucket.bucket.arn}/*"
        ]
      },
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeVpcs",
          "ec2:DescribeVpcAttribute",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeNetworkInterfaces",
          "ec2:CreateNetworkInterface",
          "ec2:CreateNetworkInterfacePermission",
          "ec2:DeleteNetworkInterface"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "es:DescribeElasticsearchDomain",
          "es:DescribeElasticsearchDomains",
          "es:DescribeElasticsearchDomainConfig",
          "es:ESHttpPost",
          "es:ESHttpPut"
        ],
        "Resource" : [
          "${aws_elasticsearch_domain.es[0].arn}",
          "${aws_elasticsearch_domain.es[0].arn}/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "es:ESHttpGet"
        ],
        "Resource" : [
          "${aws_elasticsearch_domain.es[0].arn}/_all/_settings",
          "${aws_elasticsearch_domain.es[0].arn}/_cluster/stats",
          "${aws_elasticsearch_domain.es[0].arn}/${var.kinesis_firehose_index_name}*/_mapping/*",
          "${aws_elasticsearch_domain.es[0].arn}/_nodes",
          "${aws_elasticsearch_domain.es[0].arn}/_nodes/stats",
          "${aws_elasticsearch_domain.es[0].arn}/_nodes/*/stats",
          "${aws_elasticsearch_domain.es[0].arn}/_stats",
          "${aws_elasticsearch_domain.es[0].arn}/${var.kinesis_firehose_index_name}*/_stats"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:PutLogEvents"
        ],
        "Resource" : [
          "arn:aws:logs:*:*:log-group:*:log-stream:*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "kinesis:DescribeStream",
          "kinesis:GetShardIterator",
          "kinesis:GetRecords",
          "kinesis:ListShards"
        ],
        # "Resource": [aws_kinesis_firehose_delivery_stream.firehose_stream.arn]
        "Resource" : ["arn:aws:firehose:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:deliverystream/${var.kinesis_firehose_name}"]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "lambda:InvokeFunction",
          "lambda:GetFunctionConfiguration"
        ],
        "Resource" : [
          "${aws_lambda_function.lambda_processor.arn}:$LATEST"
        ]
      }
    ]
  })
}