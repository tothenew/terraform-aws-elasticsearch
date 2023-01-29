module "elasticsearch" {
  source     = "git::https://github.com/tothenew/terraform-aws-elasticsearch.git"
  vpc_id     = "vpc-999999999999"
  subnet_ids = ["subnet-999999999999"]

  create_aws_elasticsearch     = false
  create_aws_ec2_elasticsearch = true

  #  create_iam_service_linked_role = true

  key_name = "tothenew"
}
