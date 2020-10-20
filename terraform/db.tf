resource "aws_db_instance" "default" {
  engine            = "mysql"
  engine_version    = "8.0.20"
  instance_class    = "db.t2.micro"
  name              = "rivalchess"
  username          = var.db_user
  password          = var.db_password
  allocated_storage = 20
  publicly_accessible = true
}

provider "mysql" {
  endpoint = aws_db_instance.default.endpoint
  username = aws_db_instance.default.username
  password = aws_db_instance.default.password
}

resource "mysql_database" "chess_matches" {
  name = "chess_matches"
}

resource "mysql_database" "chess_matches" {
  name = "event_log"
}
