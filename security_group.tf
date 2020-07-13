resource "aws_security_group" "kdf_sec_grp" {
  name        = "kdf-sec-grp"
  description = "Allow control the data stream"
  vpc_id      = var.vpc_id

  tags = {
    Name = "kdf-sec-grp"
  }
}

resource "aws_security_group_rule" "kdf_sec_grp_rule_out" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.kdf_sec_grp.id
  source_security_group_id = aws_security_group.es_sec_grp.id
  depends_on               = [aws_security_group.es_sec_grp]
}

resource "aws_security_group" "es_sec_grp" {
  name        = "es-sec-grp"
  description = "Allow the ENI that Kinesis Data Firehose created to make HTTPS calls"
  vpc_id      = var.vpc_id

  tags = {
    Name = "es-sec-grp"
  }
}

resource "aws_security_group_rule" "es_sec_grp_rule_in" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.es_sec_grp.id
  source_security_group_id = aws_security_group.kdf_sec_grp.id
  depends_on               = [aws_security_group.kdf_sec_grp]
}

resource "aws_security_group_rule" "es_sec_grp_rule_out" {
  type              = "egress"
  from_port         = "-1"
  to_port           = "-1"
  protocol          = "-1"
  security_group_id = aws_security_group.es_sec_grp.id
  cidr_blocks       = ["0.0.0.0/0"]
  depends_on        = [aws_security_group.kdf_sec_grp]
}
