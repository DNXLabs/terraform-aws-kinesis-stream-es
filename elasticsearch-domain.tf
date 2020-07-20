resource "aws_iam_service_linked_role" "es" {
  count = var.create_elasticsearch ? 1 : 0

  aws_service_name = "es.amazonaws.com"
}

resource "aws_elasticsearch_domain" "es" {
  count = var.create_elasticsearch ? 1 : 0

  domain_name           = var.elasticsearch_name
  elasticsearch_version = var.elasticsearch_version

  cluster_config {
    instance_type          = var.elasticsearch_instance_type
    instance_count         = var.elasticsearch_instance_count
    zone_awareness_enabled = true

    zone_awareness_config {
      availability_zone_count = var.elasticsearch_availability_zone_count
    }
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  encrypt_at_rest {
    enabled = var.elasticsearch_encrypt_at_rest
  }

  node_to_node_encryption {
    enabled = var.elasticsearch_node_to_node_encryption
  }

  domain_endpoint_options {
    enforce_https       = false
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  advanced_security_options {
    enabled = false
  }

  tags = {
    Domain = var.elasticsearch_name
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
        "Resource" : "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.elasticsearch_name}/*"
      }
    ]
  })

  depends_on = [aws_iam_service_linked_role.es]
}
