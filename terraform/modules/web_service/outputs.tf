output "web_service_url" {
  value = aws_alb.rivalchess_lb.dns_name
}