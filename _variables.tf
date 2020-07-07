variable "elasticsearch_domain_name" {}

variable "elasticsearch_volume_type" {
  default = "gp2"
}

variable "elasticsearch_volume_size" {
  default = 10
}

variable "private_subnet_ids" {
  type = list
}

variable "firehose_lambda_processor_name" {
  default = "firehose_lambda_processor"
}

# variable "kinesis_firehose_index_name" {
#   default = "kinesis"
# }

variable "kinesis_stream_bucket_name" {}

variable "vpc_id" {}