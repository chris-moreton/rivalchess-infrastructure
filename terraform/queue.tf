resource "aws_mq_broker" "rivalchess_activemq" {
  broker_name = "rivalchess-activemq-broker"

  configuration {
    id       = aws_mq_configuration.rivalchess_activemq_config.id
    revision = aws_mq_configuration.rivalchess_activemq_config.latest_revision
  }

  engine_type        = "ActiveMQ"
  engine_version     = "5.15.0"
  host_instance_type = "mq.t2.micro"
  security_groups    = [aws_security_group.rivalchess_activemq_sg.id]

  publicly_accessible = true

  apply_immediately  =  true
  logs {
    general = true
  }

  user {
    username = var.active_mq_user
    password = var.active_mq_password
  }
}

resource "aws_mq_configuration" "rivalchess_activemq_config" {
  description    = "Active MQ Configuration for rivalchess"
  name           = "rivalchess-activemq-config"
  engine_type    = "ActiveMQ"
  engine_version = "5.15.0"

  data = <<DATA
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<broker xmlns="http://activemq.apache.org/schema/core">
  <plugins>
    <forcePersistencyModeBrokerPlugin persistenceFlag="true"/>
    <statisticsBrokerPlugin/>
    <timeStampingBrokerPlugin ttlCeiling="86400000" zeroExpirationOverride="86400000"/>
  </plugins>
</broker>
DATA
}

resource "aws_security_group" "rivalchess_activemq_sg" {

  ingress {
    from_port   = 61617
    to_port     = 61617
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