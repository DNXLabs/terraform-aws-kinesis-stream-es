# terraform-aws-cloudwatch-stream-es

[![Lint Status](https://github.com/DNXLabs/terraform-aws-cloudwatch-stream-es/workflows/Lint/badge.svg)](https://github.com/DNXLabs/terraform-aws-cloudwatch-stream-es/actions)
[![LICENSE](https://img.shields.io/github/license/DNXLabs/terraform-aws-cloudwatch-stream-es)](https://github.com/DNXLabs/terraform-aws-cloudwatch-stream-es/blob/master/LICENSE)

## Usage
```terraform
module "cloudwatch_stream_es" {
    source = "./terraform-aws-cloudwatch-stream-es"

    vpc_id                     = ""
    private_subnet_ids         = ""
    elasticsearch_domain_name  = ""
    elasticsearch_volume_type  = ""
    elasticsearch_volume_size  = ""
    kinesis_stream_bucket_name = ""
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


<!--- END_TF_DOCS --->

## Authors

Module managed by [DNX Solutions](https://github.com/DNXLabs).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/terraform-aws-ecs/blob/master/LICENSE) for full details.