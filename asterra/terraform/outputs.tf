output "rds_endpoint" {
    value           = aws_db_instance.postgres.endpoint
}

output "s3_bucket_name" {
    value           = aws_s3_bucket.geojson_bucket.bucket 
}

output "aws_ecr_repository_url" {
    value           = aws_ecr_repository.ecr-repo.repository_url
}
