resource "aws_elasticsearch_domain" "es" {
  domain_name           = var.elasticsearch_domain_name
  elasticsearch_version = "7.4"

  cluster_config {
    instance_type = "r5.large.elasticsearch"
  }

  ebs_options {
    ebs_enabled = true
    volume_size  = 10
  }

  tags = {
    Domain = "TestCloudWatch",
    POC = "BrighteStream"
  }

  access_policies = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "es:*",
        "Principal": "*",
        "Effect": "Allow",
        "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.elasticsearch_domain_name}/*"
      }
    ]
  })
}
