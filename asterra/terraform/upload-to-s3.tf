resource "aws_s3_bucket" "iac_storage" {
    bucket          = var.iac_storage_bucket
}

resource "aws_s3_bucket_object" "terraform" {
    bucket          = aws_s3_bucket.iac_storage.bucket
    key             = "terraform.zip"
    source          = "../terraform.zip"
    etag           = filemd5("../terraform.zip")  
}

