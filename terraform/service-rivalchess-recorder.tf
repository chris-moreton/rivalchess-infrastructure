module rivalchess_recorder_service {

  source = "./modules/service"

  service_name = "recorder"

  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key

  rivalchess_vie_statsapi_endpoint = module.rivalchess_statsapi_service.web_service_url

  aws_vpc_region = var.aws_vpc_region

  active_mq_url = aws_mq_broker.rivalchess_activemq.instances.0.endpoints.0
  active_mq_user = var.active_mq_user
  active_mq_password = var.active_mq_password

  db_url = aws_db_instance.default.endpoint
  db_user = var.db_user
  db_password = var.db_password

  redis_url = aws_elasticache_cluster.rivalchess_redis_cache.cache_nodes.0.address

  desired_task_count = 1

  container_port = 8080

  public_subnet_ids = [aws_default_subnet.default_2a.id, aws_default_subnet.default_2b.id]
  container_memory = 512
  container_cpu = 256
  task_execution_role = aws_iam_role.rivalchessEcsTaskExecutionRole.arn
  log_group = aws_cloudwatch_log_group.rivalchess.id
  cluster_id = aws_ecs_cluster.rivalchess_ecs_cluster.id
}