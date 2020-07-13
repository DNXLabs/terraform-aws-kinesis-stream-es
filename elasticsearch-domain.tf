resource "aws_iam_service_linked_role" "es" {
  count = var.create_elasticsearch_domain ? 1 : 0

  aws_service_name = "es.amazonaws.com"
}

resource "aws_elasticsearch_domain" "es" {
  count = var.create_elasticsearch_domain ? 1 : 0

  domain_name           = var.elasticsearch_domain_name
  elasticsearch_version = "7.4"

  cluster_config {
    instance_type          = "r5.large.elasticsearch"
    instance_count         = 3
    zone_awareness_enabled = true

    zone_awareness_config {
      availability_zone_count = 3
    }
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  encrypt_at_rest {
    enabled = true
  }

  node_to_node_encryption {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https       = false
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  advanced_security_options {
    enabled = false
  }

  tags = {
    Domain = var.elasticsearch_domain_name
  }

  vpc_options {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.es_sec_grp.id]
  }

  access_policies = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "es:*",
        "Principal" : "*",
        "Effect" : "Allow",
        "Resource" : "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.elasticsearch_domain_name}/*"
      }
    ]
  })

  depends_on = [aws_iam_service_linked_role.es]
}
