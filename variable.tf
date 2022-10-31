variable "region" {
    type        = string
    description = "A string value for Launch resources in which AWS Region"
}

variable "project_name_prefix" {
    type        = string
    description = "A string value to describe prefix of all the resources"
}

variable "common_tags" {
    type        = map(string)
    description = "A map to add common tags to all the resources"
}

variable "vpc_id" {
    type        = string
    description = "A string value for VPC ID"
}

variable "security_group_ids" {
    type        = list(string)
    description = "A string value for Security Group ID"
}

variable "cloudwatch_logs_retention" {
    type = number
}

variable "subnet_ids" {
    type = list(string)
}

variable "volume_type" {
    type = string
}

variable "volume_size" {
    type = number
}

variable "elasticsearch_version" {
    type    = string
    default = "7.10"
}

variable "instance_type" {
    type = string
}

variable "account_id" {
    type = number
}

variable "instance_count" {
    type = number
}

variable "availability_zone_count" {
    type    = number
    default = 2
}

variable "zone_awareness_enabled" {
    type = bool
    default = false
}

variable "kms_key_id" {
    type    = string
}

variable "automated_snapshot_start_hour" {
    type    = number
    default = 22
}

variable "advanced_security_options_enabled" {
    type    = bool
    default = false
}
variable "master_user_name" {
    type    = string
    default = ""
}
variable "master_user_password" {
    type    = string
    default = ""
}

variable "create_iam_service_linked_role" {
    type        = bool
    default     = false
    description = "Whether to create `AWSServiceRoleForAmazonElasticsearchService` service-linked role. Set it to `false` if you already have an ElasticSearch cluster created in the AWS account and AWSServiceRoleForAmazonElasticsearchService already exists."
}