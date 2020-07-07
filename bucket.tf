resource "aws_s3_bucket" "bucket" {
  bucket = var.kinesis_stream_bucket_name
  acl    = "private"
}