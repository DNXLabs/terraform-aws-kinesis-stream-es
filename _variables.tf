variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(any)
}

variable "elasticsearch_enabled" {
  description = "If true, will create aws elasticsearch domain."
  default     = true
  type        = bool
}

variable "elasticsearch_name" {
  description = "The name of the Elasticsearch domain."
  type        = string
}

variable "elasticsearch_instance_type" {
  description = "(Optional) Instance type of data nodes in the cluster."
  default     = "r5.large.elasticsearch"
  type        = string
}

variable "elasticsearch_instance_count" {
  description = "(Optional) Number of instances in the cluster."
  default     = 3
  type        = number
}

variable "elasticsearch_version" {
  description = "(Optional) The version of Elasticsearch to deploy. Defaults to 7.4"
  default     = "7.4"
  type        = string
}

variable "elasticsearch_zone_awareness_enabled" {
  description = "(Optional) Indicates whether zone awareness is enabled, set to true for multi-az deployment. To enable awareness with three Availability Zones, the availability_zone_count within the zone_awareness_config must be set to 3."
  default     = false
  type        = bool
}

variable "elasticsearch_dedicated_master_enabled" {
  description = "(Optional) Indicates whether dedicated master nodes are enabled for the cluster."
  default     = false
  type        = bool
}

variable "elasticsearch_dedicated_master_count" {
  description = "(Optional) Number of dedicated master nodes in the cluster."
  default     = 3
  type        = number
}

variable "elasticsearch_dedicated_master_type" {
  description = "(Optional) Instance type of the dedicated master nodes in the cluster."
  default     = "m4.large.elasticsearch"
  type        = string
}

variable "elasticsearch_availability_zone_count" {
  description = "(Optional) Number of Availability Zones for the domain to use with zone_awareness_enabled. Valid values: 2 or 3."
  default     = 2
  type        = number
}

variable "elasticsearch_encrypt_at_rest" {
  description = "(Optional) Encrypt at rest options. Only available for certain instance types."
  default     = true
  type        = bool
}

variable "elasticsearch_node_to_node_encryption" {
  description = "(Optional) Node-to-node encryption options."
  default     = true
  type        = bool
}

variable "elasticsearch_volume_type" {
  description = "(Optional) The type of EBS volumes attached to data nodes."
  default     = "gp2"
  type        = string
}

variable "elasticsearch_volume_size" {
  description = "The size of EBS volumes attached to data nodes (in GB). Required if ebs_enabled is set to true."
  default     = 10
  type        = number
}

variable "firehose_lambda_processor_name" {
  default = "firehose_lambda_processor"
  type    = string
}

variable "kinesis_firehose_enabled" {
  description = "If true, will create the AWS kinesis firehose."
  default     = true
  type        = bool
}

variable "kinesis_firehose_name" {
  description = "(Required) A name to identify the stream. This is unique to the AWS account and region the Stream is created in."
  default     = "kinesis-firehose-es-stream"
  type        = string
}

variable "kinesis_firehose_index_name" {
  description = "(Required) The Elasticsearch index name."
  default     = "kinesis"
  type        = string
}

variable "kinesis_firehose_index_rotation_period" {
  default     = "OneDay"
  type        = string
  description = "(Optional) The Elasticsearch index rotation period. Index rotation appends a timestamp to the IndexName to facilitate expiration of old data. Valid values are NoRotation, OneHour, OneDay, OneWeek, and OneMonth. The default value is OneDay."
}

variable "kinesis_stream_bucket_name" {
  description = "The name of the S3 bucket to store failed documents."
  default     = "kinesis-logs-stream-backup-bucket"
  type        = string
}
