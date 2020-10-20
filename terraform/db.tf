resource "aws_db_instance" "default" {
  engine            = "mysql"
  engine_version    = "8.0.20"
  instance_class    = "db.t2.micro"
  name              = "rivalchess"
  username          = var.db_user
  password          = var.db_password
  allocated_storage = 20
  publicly_accessible = true
  vpc_security_group_ids = [aws_security_group.rivalchess_mysql_sg.id]
}

provider "mysql" {
  endpoint = aws_db_instance.default.endpoint
  username = aws_db_instance.default.username
  password = aws_db_instance.default.password
}

resource "mysql_database" "chess_matches" {
  name = "chess_matches"
}

resource "aws_security_group" "rivalchess_mysql_sg" {

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
