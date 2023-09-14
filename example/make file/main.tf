module "elastic-search" {
    source = "./terraform-aws-elasticsearch-1.0.0"
    project_name_prefix = local.workspace.project_name_prefix
    vpc_id = local.workspace.vpc_id
    subnet_ids = local.workspace.subnet_ids
    instance_type = local.workspace.instance_type
    instance_count = local.workspace.instance_count
    volume_size = local.workspace.volume_size
    key_name = local.workspace.key_name
}