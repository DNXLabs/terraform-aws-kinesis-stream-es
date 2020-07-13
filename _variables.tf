variable "aws_region" {
  description = "The AWS region to deploy into (e.g. ap-southeast-2)."
  default     = "ap-southeast-2"
}

variable "create_elasticsearch_domain" {
  description = "If true, will create aws elasticsearch domain."
  default     = "false"
}

variable "elasticsearch_domain_name" {
  type = string
}

variable "elasticsearch_volume_type" {
  default = "gp2"
  type    = string
}

variable "elasticsearch_volume_size" {
  default = 10
  type    = number
}

variable "private_subnet_ids" {
  type = list
}

variable "firehose_lambda_processor_name" {
  default = "firehose_lambda_processor"
  type    = string
}

variable "kinesis_firehose_index_name" {
  default = "kinesis"
}

variable "kinesis_stream_bucket_name" {
  type = string
}

variable "vpc_id" {
  type = string
}