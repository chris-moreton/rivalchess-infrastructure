variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_vpc_region" {
    description = "EC2 Region for the VPC"
    default = "eu-west-2"
}

variable "active_mq_user" {}
variable "active_mq_password" {}
variable "db_user" {}
variable "db_password" {}

variable "dashboard_bucket_name" { default = "rivalchess-dashboard-web" }

variable "rivalchess_generator_port" {
    default = 8080
}

variable "rivalchess_dashboard_port" {
    default = 8080
}

variable "player_count" {
    default = 0
}

variable "statsapi_count" {
    default = 0
}

variable "recorder_count" {
    default = 0
}

variable "dashboard_count" {
    default = 1
}

variable "generator_count" {
    default = 1
}
