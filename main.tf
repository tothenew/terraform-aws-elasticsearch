data "aws_caller_identity" "current" {}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  count             = var.create_aws_elasticsearch && !var.create_aws_ec2_elasticsearch ? 1 : 0
  name              = "${var.project_name_prefix}-elasticsearch-log"
  retention_in_days = var.cloudwatch_logs_retention
  tags              = merge(var.common_tags, tomap({ "Name" : "${var.project_name_prefix}-elasticsearch" }))
}

resource "aws_iam_service_linked_role" "service_linked_role" {
  count            = var.create_aws_elasticsearch && !var.create_aws_ec2_elasticsearch && var.create_iam_service_linked_role ? 1 : 0
  aws_service_name = "es.amazonaws.com"
}

resource "aws_cloudwatch_log_resource_policy" "cloudwatch_log_resource_policy" {
  count           = var.create_aws_elasticsearch && !var.create_aws_ec2_elasticsearch ? 1 : 0
  policy_name     = "${var.project_name_prefix}-elasticsearch-log-policy"
  policy_document = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:PutLogEventsBatch",
        "logs:CreateLogStream"
      ],
      "Resource": "arn:aws:logs:*"
    }
  ]
}
CONFIG
}

resource "aws_elasticsearch_domain" "elasticsearch" {
  count                 = var.create_aws_elasticsearch && !var.create_aws_ec2_elasticsearch ? 1 : 0
  domain_name           = "${var.project_name_prefix}-elasticsearch"
  elasticsearch_version = var.elasticsearch_version
  tags                  = merge(var.common_tags, tomap({ "Name" : "${var.project_name_prefix}-elasticsearch" }))

  cluster_config {
    instance_type  = "${var.instance_type}.elasticsearch"
    instance_count = var.instance_count
    zone_awareness_config {
      availability_zone_count = var.availability_zone_count
    }
    zone_awareness_enabled = var.zone_awareness_enabled
  }
  vpc_options {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }
  ebs_options {
    ebs_enabled = true
    volume_type = var.volume_type
    volume_size = var.volume_size
  }
  encrypt_at_rest {
    enabled    = true
    kms_key_id = var.kms_key_id
  }
  node_to_node_encryption {
    enabled = true
  }
  log_publishing_options {
    enabled                  = true
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.cloudwatch_log_group[0].arn
    log_type                 = "INDEX_SLOW_LOGS"
  }
  snapshot_options {
    automated_snapshot_start_hour = var.automated_snapshot_start_hour
  }
  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  advanced_security_options {
    enabled                        = var.advanced_security_options_enabled
    internal_user_database_enabled = true
    master_user_options {
      master_user_name     = var.master_user_name
      master_user_password = var.master_user_password
    }
  }

  access_policies = <<CONFIG
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Resource": "arn:aws:es:${var.region}:${data.aws_caller_identity.current.account_id}:domain/${var.project_name_prefix}-elasticsearch/*"
        }
    ]
}
CONFIG

  depends_on = [aws_iam_service_linked_role.service_linked_role]

}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
  owners = ["amazon"]
}

data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")
}

resource "aws_instance" "ec2_elasticsearch" {
  count                   = !var.create_aws_elasticsearch && var.create_aws_ec2_elasticsearch ? 1 : 0
  ami                     = var.ami_id == "" ? data.aws_ami.amazon_linux_2.id : var.ami_id
  instance_type           = var.instance_type
  subnet_id               = var.subnet_ids[0]
  vpc_security_group_ids  = var.security_group_ids
  key_name                = var.key_name
  iam_instance_profile    = var.iam_instance_profile
  ebs_optimized           = var.ebs_optimized
  disable_api_termination = var.disable_api_termination
  #disable_api_stop        = var.disable_api_stop
  user_data_base64  = base64encode(data.template_file.user_data.rendered)
  source_dest_check = var.source_dest_check

  volume_tags = merge(var.common_tags, tomap({ "Name" : "${var.project_name_prefix}-elasticsearch" }))
  tags        = merge(var.common_tags, tomap({ "Name" : "${var.project_name_prefix}-elasticsearch" }))

  root_block_device {
    delete_on_termination = var.delete_on_termination
    encrypted             = var.volume_encrypted
    kms_key_id            = var.kms_key_id
    volume_size           = var.volume_size
    volume_type           = var.volume_type
  }

}

resource "aws_ssm_parameter" "elasticsearch_host" {
  name        = "/${var.project_name_prefix}/elasticsearch/host"
  description = "Elasticsearch Host"
  type        = "String"
  value       = var.create_aws_elasticsearch && !var.create_aws_ec2_elasticsearch ? aws_elasticsearch_domain.elasticsearch[0].endpoint : aws_instance.ec2_elasticsearch[0].private_ip
  tags        = merge(var.common_tags, tomap({ "Name" : "${var.project_name_prefix}-elasticsearch" }))
}

resource "aws_ssm_parameter" "elasticsearch_username" {
  name        = "/${var.project_name_prefix}/elasticsearch/username"
  description = "Elasticsearch Username"
  type        = "SecureString"
  value       = ""
  tags        = merge(var.common_tags, tomap({ "Name" : "${var.project_name_prefix}-elasticsearch" }))
}

resource "aws_ssm_parameter" "elasticsearch_password" {
  name        = "/${var.project_name_prefix}/elasticsearch/password"
  description = "Elasticsearch Password"
  type        = "SecureString"
  value       = ""
  tags        = merge(var.common_tags, tomap({ "Name" : "${var.project_name_prefix}-elasticsearch" }))
}
