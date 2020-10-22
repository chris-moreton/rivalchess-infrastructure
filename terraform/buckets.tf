resource "aws_s3_bucket" "rivalchess-jars" {
  bucket = "rivalchess-jars"
  acl    = "public-read"
}

resource "aws_s3_bucket" "rivalchess-openings" {
  bucket = "rivalchess-openings"
  acl    = "public-read"
}
