# terraform-aws-kinesis-stream-es

[![Lint Status](https://github.com/DNXLabs/terraform-aws-kinesis-stream-es/workflows/Lint/badge.svg)](https://github.com/DNXLabs/terraform-aws-kinesis-stream-es/actions)
[![LICENSE](https://img.shields.io/github/license/DNXLabs/terraform-aws-kinesis-stream-es)](https://github.com/DNXLabs/terraform-aws-kinesis-stream-es/blob/master/LICENSE)

## Usage
```terraform
module "kinesis_stream_es" {
    source = "git::https://github.com/DNXLabs/terraform-aws-kinesis-stream-es.git"

    vpc_id                      = ""
    private_subnet_ids          = ""
    create_elasticsearch        = ""
    elasticsearch_domain_name   = ""
    elasticsearch_volume_type   = ""
    elasticsearch_volume_size   = ""
    kinesis_stream_bucket_name  = ""
}
```

When you enable Kinesis Data Firehose data transformation, Kinesis Data Firehose buffers incoming
data up to 3 MB by default. `(To adjust the buffering size, use the ProcessingConfiguration API
with the ProcessorParameter called BufferSizeInMBs.)` Kinesis Data Firehose then invokes the
specified Lambda function asynchronously with each buffered batch using the AWS Lambda synchronous
invocation mode. The transformed data is sent from Lambda to Kinesis Data Firehose. Kinesis Data
Firehose then sends it to the destination when the specified destination buffering size or buffering
interval is reached, whichever happens first.

#### Important
> The Lambda synchronous invocation mode has a payload size limit of 6 MB for both the request
and the response. Make sure that your buffering size for sending the request to the function
is less than or equal to 6 MB. Also ensure that the response that your function returns doesn't
exceed 6 MB.

For data delivery to Amazon ES, Kinesis Data Firehose buffers incoming records based on the
buffering configuration of your delivery stream. It then generates an Elasticsearch bulk request to
index multiple records to your Elasticsearch cluster. Make sure that your record is UTF-8 encoded
and flattened to a single-line JSON object before you send it to Kinesis Data Firehose. Also, the
rest.action.multi.allow_explicit_index option for your Elasticsearch cluster must be set to
true (default) to take bulk requests with an explicit index that is set per record. For more information, see
Amazon ES Configure Advanced Options in the Amazon Elasticsearch Service Developer Guide.

The frequency of data delivery to Amazon ES is determined by the Elasticsearch Buffer size and
Buffer interval values that you configured for your delivery stream. Kinesis Data Firehose buffers
incoming data before delivering it to Amazon ES. You can configure the values for Elasticsearch
Buffer size (1–100 MB) or Buffer interval (60–900 seconds), and the condition satisfied first triggers
data delivery to Amazon ES.

<!--- BEGIN_TF_DOCS --->

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.20 |

## Providers

| Name | Version |
|------|---------|
| archive | n/a |
| aws | n/a |
| null | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create\_elasticsearch | If true, will create aws elasticsearch domain. | `bool` | `true` | no |
| elasticsearch\_availability\_zone\_count | n/a | `number` | `2` | no |
| elasticsearch\_dedicated\_master\_count | n/a | `number` | `3` | no |
| elasticsearch\_dedicated\_master\_enabled | n/a | `bool` | `false` | no |
| elasticsearch\_dedicated\_master\_type | n/a | `string` | `"m4.large.elasticsearch"` | no |
| elasticsearch\_encrypt\_at\_rest | n/a | `bool` | `true` | no |
| elasticsearch\_instance\_count | n/a | `number` | `3` | no |
| elasticsearch\_instance\_type | n/a | `string` | `"r5.large.elasticsearch"` | no |
| elasticsearch\_name | n/a | `string` | n/a | yes |
| elasticsearch\_node\_to\_node\_encryption | n/a | `bool` | `true` | no |
| elasticsearch\_version | n/a | `string` | `"7.4"` | no |
| elasticsearch\_volume\_size | n/a | `number` | `10` | no |
| elasticsearch\_volume\_type | n/a | `string` | `"gp2"` | no |
| elasticsearch\_zone\_awareness\_enabled | n/a | `bool` | `false` | no |
| firehose\_lambda\_processor\_name | n/a | `string` | `"firehose_lambda_processor"` | no |
| kinesis\_firehose\_enabled | n/a | `bool` | `true` | no |
| kinesis\_firehose\_index\_name | n/a | `string` | `"kinesis"` | no |
| kinesis\_firehose\_index\_rotation\_period | Allowed values: NoRotation \| OneDay \| OneHour \| OneMonth \| OneWeek | `string` | `"NoRotation"` | no |
| kinesis\_firehose\_name | n/a | `string` | `"kinesis-firehose-es-stream"` | no |
| kinesis\_stream\_bucket\_name | n/a | `string` | `"kinesis-logs-stream-backup-bucket"` | no |
| private\_subnet\_ids | n/a | `list` | n/a | yes |
| vpc\_id | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| kinesis\_arn | n/a |

<!--- END_TF_DOCS --->

## Authors

Module managed by [DNX Solutions](https://github.com/DNXLabs).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/terraform-aws-kinesis-stream-es/blob/master/LICENSE) for full details.