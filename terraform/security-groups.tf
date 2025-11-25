resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP/HTTPS traffic from internet"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "alb-sg"
    Environment = var.env
  }
}
resource "aws_security_group" "app_sg" {
  name        = "application-sg"
  description = "Allow traffic from ALB to microservices"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow service traffic from ALB"
    from_port       = 3000
    to_port         = 9000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "application-sg"
    Environment = var.env
  }
}
resource "aws_security_group" "kafka_sg" {
  name        = "kafka-sg"
  description = "Allow internal Kafka + Zookeeper communication"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 2181
    to_port         = 2181
    protocol        = "tcp"
    security_groups = [aws_security_group.kafka_sg.id]
  }

  ingress {
    from_port       = 9092
    to_port         = 9092
    protocol        = "tcp"
    security_groups = [aws_security_group.kafka_sg.id]
  }

  ingress {
    from_port       = 2888
    to_port         = 2888
    protocol        = "tcp"
    security_groups = [aws_security_group.kafka_sg.id]
  }

  ingress {
    from_port       = 3888
    to_port         = 3888
    protocol        = "tcp"
    security_groups = [aws_security_group.kafka_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "kafka-sg"
    Environment = var.env
  }
}
resource "aws_security_group" "rds_sg" {
  name        = "learning-platform-rds-sg"
  description = "Security group for RDS PostgreSQL servers"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow Postgres from Application Layer"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = var.app_sg_ids
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "learning-platform-rds-sg"
    Environment = var.env
  }
}
