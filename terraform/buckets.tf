resource "aws_s3_bucket" "rivalchess-jars" {
  bucket = "rivalchess-jars"
  acl    = "public-read"
}