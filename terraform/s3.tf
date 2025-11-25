##############################
# S3 - User Management Bucket
##############################

resource "aws_s3_bucket" "user_mgmt_bucket" {
  bucket        = "user-management-storage-${var.env}"
  force_destroy = false

  tags = {
    Name        = "user-management-storage"
    Environment = var.env
  }
}

resource "aws_s3_bucket_versioning" "user_mgmt_versioning" {
  bucket = aws_s3_bucket.user_mgmt_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "user_mgmt_public" {
  bucket                  = aws_s3_bucket.user_mgmt_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

####################################
# S3 - Document Service Bucket
####################################

resource "aws_s3_bucket" "document_bucket" {
  bucket        = "document-service-storage-${var.env}"
  force_destroy = false

  tags = {
    Name        = "document-service-storage"
    Environment = var.env
  }
}

resource "aws_s3_bucket_versioning" "document_bucket_versioning" {
  bucket = aws_s3_bucket.document_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "document_bucket_public" {
  bucket                  = aws_s3_bucket.document_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#########################################
# S3 - Quiz Service Bucket
#########################################

resource "aws_s3_bucket" "quiz_bucket" {
  bucket        = "quiz-service-storage-${var.env}"
  force_destroy = false

  tags = {
    Name        = "quiz-service-storage"
    Environment = var.env
  }
}

resource "aws_s3_bucket_versioning" "quiz_bucket_versioning" {
  bucket = aws_s3_bucket.quiz_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "quiz_bucket_public" {
  bucket                  = aws_s3_bucket.quiz_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
