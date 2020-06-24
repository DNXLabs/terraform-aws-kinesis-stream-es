# provider "aws" {
#   region                      = "ap-southeast-2"
#   access_key                  = "access_key"
#   secret_key                  = "secret_key"
#   s3_force_path_style         = true
#   skip_credentials_validation = true
#   skip_metadata_api_check     = true
#   skip_requesting_account_id  = true

#   endpoints {
#     s3                    = "http://localhost:4572"
#     lambda                = "http://localhost:4574"
#     kinesis               = "http://localhost:4568"
#     firehose              = "http://localhost:4573"
#     cloud_watch           = "http://localhost:4582"
#     cloud_watch_logs      = "http://localhost:4586"
#     iam                   = "http://localhost:4593"
#     elasticsearch_service = "http://localhost:4578"
#   }
# }