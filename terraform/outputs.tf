output "vpc_id" {
  description = "Main VPC ID"
  value       = aws_vpc.main.id
}
output "vpc_id" {
  description = "Main VPC ID"
  value       = aws_vpc.main.id
}
output "private_subnet_ids" {
  description = "Private subnets for microservices"
  value = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
}
output "db_subnet_ids" {
  description = "Database subnet IDs"
  value = [
    aws_subnet.db_1.id,
    aws_subnet.db_2.id
  ]
}
output "kafka_subnet_ids" {
  description = "Kafka subnet IDs"
  value = [
    aws_subnet.kafka_1.id,
    aws_subnet.kafka_2.id
  ]
}
output "alb_sg_id" {
  description = "Security group for ALB"
  value       = aws_security_group.alb_sg.id
}
output "app_sg_id" {
  description = "Security group for microservices"
  value       = aws_security_group.app_sg.id
}
output "kafka_sg_id" {
  description = "Security group for kafka cluster"
  value       = aws_security_group.kafka_sg.id
}
