resource "aws_elasticache_subnet_group" "default" {
  name       = "rivalchess-cache-subnet"
  subnet_ids = [aws_default_subnet.default_2a.id, aws_default_subnet.default_2b.id]
}

resource "aws_elasticache_cluster" "rivalchess_redis_cache" {
  cluster_id           = "rivalchess-redis-cluster"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  security_group_ids   = [aws_security_group.redis_security_group.id]
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.default.name
}

resource "aws_security_group" "redis_security_group" {

  name = "redis-security-group"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0 # Allowing any incoming port
    to_port     = 0 # Allowing any outgoing port
    protocol    = "-1" # Allowing any outgoing protocol
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }
}