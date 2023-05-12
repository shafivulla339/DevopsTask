output "input_bucket_name" {
  value = aws_s3_bucket.input_bucket.bucket
}

output "output_bucket_name" {
  value = aws_s3_bucket.output_bucket.bucket
}

output "ecr_repository_url" {
  value = aws_ecr_repository.repository.repository_url
}
