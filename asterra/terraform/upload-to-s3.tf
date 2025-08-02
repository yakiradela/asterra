resource "aws_s3_bucket" "iac_storage" {
  bucket = var.iac_storage_bucket
}

resource "aws_s3_bucket_acl" "iac_storage_acl" {
  bucket = aws_s3_bucket.iac_storage.id
  acl    = "private"
}

resource "aws_s3_object" "terraform" {
  bucket = aws_s3_bucket.iac_storage.bucket
  key    = "terraform.zip"
}

