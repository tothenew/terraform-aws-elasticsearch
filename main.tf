resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
    name              = "${var.project_name_prefix}-elasticsearch-log"
    retention_in_days = var.cloudwatch_logs_retention
    tags              = merge(var.common_tags, tomap({ "Name" : "${var.project_name_prefix}-elasticsearch" }))
}

resource "aws_iam_service_linked_role" "service_linked_role" {
    count            = var.create_iam_service_linked_role ? 1 : 0
    aws_service_name = "es.amazonaws.com"
}

resource "aws_cloudwatch_log_resource_policy" "cloudwatch_log_resource_policy" {
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
    domain_name           = "${var.project_name_prefix}-elasticsearch"
    elasticsearch_version = var.elasticsearch_version
    tags                  = merge(var.common_tags, tomap({ "Name" : "${var.project_name_prefix}-elasticsearch" }))

    cluster_config {
        instance_type  = var.instance_type
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
        cloudwatch_log_group_arn = aws_cloudwatch_log_group.cloudwatch_log_group.arn
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
            "Resource": "arn:aws:es:${var.region}:${var.account_id}:domain/${var.project_name_prefix}-elasticsearch/*"
        }
    ]
}
CONFIG

}