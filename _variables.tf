variable "kinesis_firehose_enabled" {
  default = true
  type    = bool
}

variable "kinesis_firehose_name" {
  default = "kinesis-firehose-es-stream"
  type    = string
}

variable "create_elasticsearch" {
  description = "If true, will create aws elasticsearch domain."
  default     = true
  type        = bool
}

variable "elasticsearch_name" {
  type = string
}

variable "elasticsearch_instance_type" {
  default = "r5.large.elasticsearch"
  type    = string
}

variable "elasticsearch_version" {
  default = "7.4"
  type    = string
}

variable "elasticsearch_zone_awareness_enabled" {
  default = false
  type    = bool
}

variable "elasticsearch_dedicated_master_enabled" {
  default = false
  type    = bool
}

variable "elasticsearch_dedicated_master_count" {
  default = 3
  type    = number
}

variable "elasticsearch_dedicated_master_type" {
  default = "m4.large.elasticsearch"
  type    = string
}

variable "elasticsearch_availability_zone_count" {
  default = 2
  type    = number
}

variable "elasticsearch_instance_count" {
  default = 3
  type    = number
}

variable "elasticsearch_encrypt_at_rest" {
  default = true
  type    = bool
}

variable "elasticsearch_node_to_node_encryption" {
  default = true
  type    = bool
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
  type    = string
}

variable "kinesis_firehose_index_rotation_period" {
  default     = "NoRotation"
  type        = string
  description = "Allowed values: NoRotation | OneDay | OneHour | OneMonth | OneWeek"
}

variable "kinesis_stream_bucket_name" {
  type = string
}

variable "vpc_id" {
  type = string
}
