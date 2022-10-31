module "elasticsearch" {
    source                    = "git::https://github.com/tothenew/terraform-aws-elasticsearch.git"
    account_id                = var.account_id
    zone_awareness_enabled    = false
    cloudwatch_logs_retention = 7
    common_tags               = local.common_tags
    instance_count            = 1
    instance_type             = var.instance_type
    project_name_prefix       = local.project_name_prefix
    region                    = var.region
    security_group_id         = [var.elasticsearch_sg_id]
    subnet_ids                = var.subnet_ids
    volume_size               = 10
    volume_type               = "gp3"
    vpc_id                    = var.vpc_id
    kms_key_id                = var.kms_key_id
}