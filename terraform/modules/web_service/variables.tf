variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_vpc_region" {
  description = "EC2 Region for the VPC"
  default = "eu-west-2"
}

variable "vpc_id" {}

variable "service_name" {}

variable "active_mq_url" {}
variable "active_mq_user" {}
variable "active_mq_password" {}

variable "db_url" {}
variable "db_user" {}
variable "db_password" {}

variable "redis_url" {}

variable "desired_task_count" {
  default = 1
}

variable "container_port" {
  default = 8080
}

variable "rivalchess_vie_statsapi_endpoint" {
  default = ""
}

variable "public_subnet_ids" {}
variable "container_memory" {}
variable "container_cpu" {}
variable "task_execution_role" {}
variable "log_group" {}
variable "cluster_id" {}
