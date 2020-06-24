resource "aws_iam_role" "firehose_role" {
  name = "firehose_test_role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "firehose.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  })
}

resource "aws_iam_role_policy" "firehose_role" {
  role = aws_iam_role.firehose_role.name

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObjectAcl",
          "s3:PutObject"
        ],
        "Resource": [
          "${aws_s3_bucket.bucket.arn}",
          "${aws_s3_bucket.bucket.arn}/*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "es:DescribeElasticsearchDomain",
          "es:DescribeElasticsearchDomains",
          "es:DescribeElasticsearchDomainConfig",
          "es:ESHttpPost",
          "es:ESHttpPut"
        ],
        "Resource": [
          "${aws_elasticsearch_domain.es.arn}",
          "${aws_elasticsearch_domain.es.arn}/*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "es:ESHttpGet"
        ],
        "Resource": [
          "${aws_elasticsearch_domain.es.arn}/_all/_settings",
          "${aws_elasticsearch_domain.es.arn}/_cluster/stats",
          "${aws_elasticsearch_domain.es.arn}/${aws_kinesis_firehose_delivery_stream.test_stream.elasticsearch_configuration[0].index_name}*/_mapping/*",
          "${aws_elasticsearch_domain.es.arn}/_nodes",
          "${aws_elasticsearch_domain.es.arn}/_nodes/stats",
          "${aws_elasticsearch_domain.es.arn}/_nodes/*/stats",
          "${aws_elasticsearch_domain.es.arn}/_stats",
          "${aws_elasticsearch_domain.es.arn}/${aws_kinesis_firehose_delivery_stream.test_stream.elasticsearch_configuration[0].index_name}*/_stats"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "logs:PutLogEvents"
        ],
        "Resource": [
          "arn:aws:logs:*:*:log-group:*:log-stream:*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "kinesis:DescribeStream",
          "kinesis:GetShardIterator",
          "kinesis:GetRecords",
          "kinesis:ListShards"
        ],
        "Resource": ["${aws_kinesis_firehose_delivery_stream.test_stream.arn}"]
      },
      {
        "Effect": "Allow",
        "Action": [
          "lambda:InvokeFunction",
          "lambda:GetFunctionConfiguration"
        ],
        "Resource": [
          "${aws_lambda_function.lambda_processor.arn}:$LATEST"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "cloudwatch_logs" {
  name = "cloudwatch_logs_to_firehose"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "logs.${data.aws_region.current.name}.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": "",
      },
    ],
  })
}

resource "aws_iam_role_policy" "cloudwatch_logs" {
  role = aws_iam_role.cloudwatch_logs.name

  policy = jsonencode({
    "Statement": [
      {
        "Effect": "Allow",
        "Action": ["firehose:*"],
        "Resource": [aws_kinesis_firehose_delivery_stream.test_stream.arn],
      },
    ],
  })
}