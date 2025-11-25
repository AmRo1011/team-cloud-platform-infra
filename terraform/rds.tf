###############################################
# RDS SUBNET GROUP
###############################################

resource "aws_db_subnet_group" "learning_platform_db_subnets" {
  name       = "learning-platform-db-subnet-group"
  subnet_ids = var.db_subnet_ids
  description = "Subnet group for RDS databases used by learning platform"

  tags = {
    Name        = "learning-platform-db-subnet-group"
    Environment = var.env
  }
}

###############################################
# RDS SECURITY GROUP
###############################################

resource "aws_security_group" "rds_sg" {
  name        = "learning-platform-rds-sg"
  description = "Security group for RDS PostgreSQL servers"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow Postgres traffic from application layer"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
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

###############################################
# USERS DATABASE
###############################################

resource "aws_db_instance" "users_db" {
  identifier              = "users-db-${var.env}"
  engine                  = "postgres"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  max_allocated_storage   = 100
  db_subnet_group_name    = aws_db_subnet_group.learning_platform_db_subnets.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  publicly_accessible     = false
  skip_final_snapshot     = true

  username = var.db_username
  password = var.db_password

  tags = {
    Name        = "users-db"
    Environment = var.env
  }
}

resource "aws_db_instance" "documents_db" {
  identifier              = "documents-db-${var.env}"
  engine                  = "postgres"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  max_allocated_storage   = 100
  db_subnet_group_name    = aws_db_subnet_group.learning_platform_db_subnets.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  publicly_accessible     = false
  skip_final_snapshot     = true

  username = var.db_username
  password = var.db_password

  tags = {
    Name        = "documents-db"
    Environment = var.env
  }
}

resource "aws_db_instance" "quiz_db" {
  identifier              = "quiz-db-${var.env}"
  engine                  = "postgres"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  max_allocated_storage   = 100
  db_subnet_group_name    = aws_db_subnet_group.learning_platform_db_subnets.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  publicly_accessible     = false
  skip_final_snapshot     = true

  username = var.db_username
  password = var.db_password

  tags = {
    Name        = "quiz-db"
    Environment = var.env
  }
}

resource "aws_db_instance" "chat_db" {
  identifier              = "chat-db-${var.env}"
  engine                  = "postgres"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  max_allocated_storage   = 100
  db_subnet_group_name    = aws_db_subnet_group.learning_platform_db_subnets.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  publicly_accessible     = false
  skip_final_snapshot     = true

  username = var.db_username
  password = var.db_password

  tags = {
    Name        = "chat-db"
    Environment = var.env
  }
}
