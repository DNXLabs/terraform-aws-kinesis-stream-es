resource "aws_cloudformation_stack" "firehose_stream" {
  name = var.kinesis_firehose_name

  parameters = {
    DeliveryStreamName  = var.kinesis_firehose_name
    DeliveryStreamType  = "DirectPut"
    IndexRotationPeriod = var.kinesis_firehose_index_rotation_period
    LogGroupName        = aws_cloudwatch_log_group.kinesis_delivery.name
    LogStreamName       = aws_cloudwatch_log_stream.s3_delivery.name
    DomainARN           = aws_elasticsearch_domain.es[0].arn
    LambdaArn           = aws_lambda_function.lambda_processor.arn
    RoleARN             = aws_iam_role.firehose_role[0].arn
    BucketARN           = aws_s3_bucket.bucket.arn
    IndexName           = var.kinesis_firehose_index_name
    SecurityGroupIds    = aws_security_group.kdf_sec_grp.id
    SubnetIds           = var.private_subnet_ids[0]
  }

  template_body = <<STACK
{
  "AWSTemplateFormatVersion": "2010-09-09",
  "Description": "The AWS CloudFormation template for Kinesis Firehose Stream",
  "Parameters": {
    "DeliveryStreamName": {
      "Type": "String",
      "Default": ""
    },
    "DeliveryStreamType": {
      "Type": "String",
      "Default": "DirectPut"
    },
    "IndexRotationPeriod": {
      "Type": "String",
      "Default": "NoRotation"
    },
    "LogGroupName": {
      "Type": "String",
      "Default": ""
    },
    "LogStreamName": {
      "Type": "String",
      "Default": ""
    },
    "DomainARN": {
      "Type": "String",
      "Default": ""
    },
    "IndexName": {
      "Type": "String",
      "Default": ""
    },
    "LambdaArn": {
      "Type": "String",
      "Default": ""
    },
    "RoleARN": {
      "Type": "String",
      "Default": ""
    },
    "BucketARN": {
      "Type": "String",
      "Default": ""
    },
    "SecurityGroupIds": {
      "Type": "List<String>",
      "Default": ""
    },
    "SubnetIds": {
      "Type": "List<String>",
      "Default": ""
    }
  },
  "Resources": {
    "KinesisFirehoseDeliveryStream": {
      "Type": "AWS::KinesisFirehose::DeliveryStream",
      "Properties": {
        "DeliveryStreamName": { "Ref" : "DeliveryStreamName" },
        "DeliveryStreamType": { "Ref" : "DeliveryStreamType" },
        "ElasticsearchDestinationConfiguration": {
          "BufferingHints": {
            "IntervalInSeconds": 60,
            "SizeInMBs": 5
          },
          "CloudWatchLoggingOptions": {
            "Enabled": true,
            "LogGroupName": { "Ref" : "LogGroupName" },
            "LogStreamName": { "Ref" : "LogStreamName" }
          },
          "DomainARN": { "Ref" : "DomainARN" },
          "IndexName": { "Ref" : "IndexName" },
          "IndexRotationPeriod": { "Ref" : "IndexRotationPeriod" },
          "ProcessingConfiguration": {
            "Enabled" : true,
            "Processors" : [
              {
                "Parameters": [
                  {
                    "ParameterName" : "LambdaArn",
                    "ParameterValue" : { "Ref" : "LambdaArn" }
                  }
                ],
                "Type" : "Lambda"
              }
            ]
          },
          "RetryOptions": {
            "DurationInSeconds": 60
          },
          "RoleARN": { "Ref" : "RoleARN" },
          "S3BackupMode": "FailedDocumentsOnly",
          "S3Configuration": {
            "BucketARN": { "Ref" : "BucketARN" },
            "BufferingHints": {
              "IntervalInSeconds": 60,
              "SizeInMBs": 5
            },
            "CompressionFormat": "GZIP",
            "RoleARN": { "Ref" : "RoleARN" },
            "CloudWatchLoggingOptions": {
              "Enabled": true,
              "LogGroupName": { "Ref" : "LogGroupName" },
              "LogStreamName": { "Ref" : "LogStreamName" }
            }
          },
          "VpcConfiguration": {
            "RoleARN": { "Ref" : "RoleARN" },
            "SecurityGroupIds" : { "Ref" : "SecurityGroupIds" },
            "SubnetIds" : { "Ref" : "SubnetIds" }
          }
        }
      }
    }
  },
  "Outputs": {
    "Arn": {
      "Description": "Kinesis Arn",
      "Value": { "Fn::GetAtt": [ "KinesisFirehoseDeliveryStream", "Arn" ] }
    }
  }
}
STACK
}

resource "aws_cloudwatch_log_group" "kinesis_delivery" {
  name = "/aws/kinesisfirehose/kinesis-firehose-es-stream"
}

resource "aws_cloudwatch_log_stream" "elasticsearch_delivery" {
  name           = "ElasticsearchDelivery"
  log_group_name = aws_cloudwatch_log_group.kinesis_delivery.name
}

resource "aws_cloudwatch_log_stream" "s3_delivery" {
  name           = "S3Delivery"
  log_group_name = aws_cloudwatch_log_group.kinesis_delivery.name
}
