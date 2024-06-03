# Create an S3 bucket
resource "aws_s3_bucket" "project_bucket" {
  bucket = "sam-s3bucket24"

  tags = {
    Name        = "Project-Bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "sn_versioning" {
  bucket = aws_s3_bucket.project_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket    = "Project-Bucket"
    key       = "wordpress-website"
    region    = "us-east-1"
  }
}
