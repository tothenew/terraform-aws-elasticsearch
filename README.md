# terraform-aws-elasticsearch

# Testing

## Usage

```
module "elasticsearch" {
    source              = "git::https://github.com/tothenew/terraform-aws-elasticsearch.git"
    common_tags         = {
        "Project"     = "ToTheNew",
        "Environment" = "dev"
    }
    instance_count      = 1
    instance_type       = "t3.small"
    project_name_prefix = "dev-tothenew"
    region              = "us-east-1"
    security_group_ids  = ["sg-999999999999"]
    subnet_ids          = ["subnet-999999999999"]
    volume_size = 10
    vpc_id      = "vpc-999999999999"

    create_aws_elasticsearch     = false
    create_aws_ec2_elasticsearch = true

    #  create_iam_service_linked_role = true
    #  cloudwatch_logs_retention = 7

    kms_key_id              = "nj23ihun-wcsn2-mnwnj-dsaxsa"
    key_name                = "tothenew"
    iam_instance_profile    = "tothenew"
    disable_api_termination = true
    disable_api_stop        = true
}
```

<!--- BEGIN_TF_DOCS --->

<!--- END_TF_DOCS --->
