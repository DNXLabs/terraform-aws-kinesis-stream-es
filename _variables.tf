variable "bucket_name" {
  default = "kinesis-brighte-stream-bucket"
}

variable "elasticsearch_domain_name" {
  default = "cloud-watch"
}

variable "firehose_lambda_processor_name" {
  default = "firehose_lambda_processor"
}