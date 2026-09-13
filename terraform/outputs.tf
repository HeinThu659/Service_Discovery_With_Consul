output "dashboard_url" {
  description = "URL of the Dashboard application"

  value = "http://${aws_lb.dashboard.dns_name}:8888"
}

output "s3_bucket_name" {
  description = "S3 bucket containing application binaries"

  value = aws_s3_bucket.consul-demo.bucket
}