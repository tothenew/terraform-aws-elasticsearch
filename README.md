# terraform-aws-elasticsearch

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

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| advanced\_security\_options\_enabled | Advance Security Option to Enable for Authentication | `bool` | `false` | no |
| automated\_snapshot\_start\_hour | AWS elasticsearch snapshot start hour time | `number` | `22` | no |
| availability\_zone\_count | Availability Zone count when zone is enabled | `number` | `2` | no |
| cloudwatch\_logs\_retention | Cloudwatch logs of the AWS Elasticsearch retention period | `number` | `7` | no |
| common\_tags | A map to add common tags to all the resources | `map(string)` | n/a | yes |
| create\_aws\_ec2\_elasticsearch | If you want to create the AWS EC2 instance elasticsearch enable this check | `bool` | `true` | no |
| create\_aws\_elasticsearch | If you want to create the AWS elasticsearch enable this check | `bool` | `false` | no |
| create\_iam\_service\_linked\_role | Whether to create `AWSServiceRoleForAmazonElasticsearchService` service-linked role. Set it to `false` if you already have an ElasticSearch cluster created in the AWS account and AWSServiceRoleForAmazonElasticsearchService already exists. | `bool` | `false` | no |
| delete\_on\_termination | Delete the volume after the termination of the EC2 | `bool` | `true` | no |
| disable\_api\_stop | Disable API stop means disable instance stop | `bool` | `false` | no |
| disable\_api\_termination | Disable API termination means disable instance termination | `bool` | `false` | no |
| ebs\_optimized | EBS optimized enable | `bool` | `true` | no |
| elasticsearch\_version | AWS Elasticsearch version default is 7.10 which is latest | `string` | `"7.10"` | no |
| iam\_instance\_profile | IAM Profile name for launching the EC2 instance | `string` | `"undefined"` | no |
| instance\_count | Number of node of AWS elasticsearch you want to launch | `number` | `1` | no |
| instance\_type | Instance type of the Server | `string` | n/a | yes |
| key\_name | Key name for launching the EC2 instance | `string` | `"undefined"` | no |
| kms\_key\_id | KMS key ID for creating AWS resources | `string` | n/a | yes |
| master\_user\_name | Username of the security option enabled | `string` | `""` | no |
| master\_user\_password | Password of the security option enabled | `string` | `""` | no |
| project\_name\_prefix | A string value to describe prefix of all the resources | `string` | n/a | yes |
| region | A string value for Launch resources in which AWS Region | `string` | n/a | yes |
| security\_group\_ids | A string value for Security Group ID | `list(string)` | n/a | yes |
| source\_dest\_check | Source destination Check | `bool` | `true` | no |
| subnet\_ids | Subnet Ids where server will be launched | `list(string)` | n/a | yes |
| volume\_encrypted | Volume can be encrypted through this check | `bool` | `true` | no |
| volume\_size | Volume size of the EC2 instance | `number` | `100` | no |
| volume\_type | Volume type for EC2 instance default latest type | `string` | `"gp3"` | no |
| vpc\_id | A string value for VPC ID | `string` | n/a | yes |
| zone\_awareness\_enabled | Zone Awareness enable for multi AZ | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| ec2\_elasticsearch\_private\_ip | n/a |
| elasticsearch\_arn | n/a |
| elasticsearch\_domain\_id | n/a |
| elasticsearch\_domain\_name | n/a |
| elasticsearch\_endpoint | n/a |
| kibana\_endpoint | n/a |

<!--- END_TF_DOCS --->