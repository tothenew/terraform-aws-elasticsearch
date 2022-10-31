locals {
    project_name_prefix = "${terraform.workspace}-${var.project_name_prefix}"

    common_tags = merge(
        var.common_tags,
        tomap({
            "Project"     = var.project,
            "Environment" = terraform.workspace
        })
    )
}