terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    mysql = {
      source = "terraform-providers/mysql"
    }
  }
  backend "s3" {
    bucket = "rivalchess-terraform-eu-west-2"
    region = "eu-west-2"
  }
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_vpc_region
}