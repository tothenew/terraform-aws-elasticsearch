variable "region" {
    type        = string
    description = "A string value for Launch resources in which AWS Region"
    default     = "us-east-1"
}
variable "profile" {
    type        = string
    description = "A string value for setting AWS Profile"
}
variable "project_name_prefix" {
    type        = string
    description = "A string value to describe prefix of all the resources"
}
variable "common_tags" {
    type        = map(string)
    description = "A map to add common tags to all the resources"
    default = {
        "Feature" : "application"
    }
}
variable "project" {
    type        = string
    description = "A string value for tag as Project Name"
}
variable "account_id" {
    type = number
    default = 999999999999
}
variable "elasticsearch_sg_id" {

}
variable "subnet_ids" {}
variable "vpc_id" {}
variable "kms_key_id" {}
variable "instance_type" {}