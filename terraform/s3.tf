resource "aws_s3_bucket" "consul-demo" {
  bucket = "${local.name_prefix}-artifacts"

  force_destroy = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-artifacts"

    }
  )
}

resource "aws_s3_object" "dashboard-service" {
  bucket = aws_s3_bucket.consul-demo.id
  key    = "dashboard-service_linux_amd64"

  source = "${path.module}/../dashboard-service_linux_amd64"
  etag   = filemd5("${path.module}/../dashboard-service_linux_amd64")
}

resource "aws_s3_object" "counting-service" {
  bucket = aws_s3_bucket.consul-demo.id
  key    = "counting-service_linux_amd64"

  source = "${path.module}/../counting-service_linux_amd64"
  etag   = filemd5("${path.module}/../counting-service_linux_amd64")
}