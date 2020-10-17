resource "aws_default_vpc" "default" {

}

resource "aws_default_subnet" "default" {
  availability_zone = "eu-west-2a"
}