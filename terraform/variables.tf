variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_vpc_region" {
    description = "EC2 Region for the VPC"
    default = "eu-west-2"
}

variable "active_mq_user" {
}

variable "active_mq_password" {
}

