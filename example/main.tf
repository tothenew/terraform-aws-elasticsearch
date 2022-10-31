module "elasticsearch" {
    source                    = "git::https://github.com/tothenew/terraform-aws-elasticsearch.git"
    account_id                = var.account_id
    zone_awareness_enabled    = var.zone_awareness_enabled
    cloudwatch_logs_retention = var.cloudwatch_logs_retention
    common_tags               = local.common_tags
    instance_count            = var.instance_count
    instance_type             = var.instance_type
    project_name_prefix       = local.project_name_prefix
    region                    = var.region
    security_group_id         = [var.security_group_id]
    subnet_ids                = var.subnet_ids
    volume_size               = var.volume_size
    volume_type               = var.volume_type
    vpc_id                    = var.vpc_id
    kms_key_id                = var.kms_key_id
}