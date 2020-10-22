resource "aws_default_vpc" "default" {

}

resource "aws_default_subnet" "default_2a" {
  availability_zone = "eu-west-2a"
}

resource "aws_default_subnet" "default_2b" {
  availability_zone = "eu-west-2b"
}
