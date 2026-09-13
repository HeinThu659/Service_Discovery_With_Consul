locals {

  counting_service = templatefile(
    "${path.module}/templates/counting.service.tpl",
    {
      service_name  = var.counting_service_name
      app_user      = var.counting_app_user
      app_directory = var.counting_app_directory
      app_port      = var.counting_app_port
    }
  )


  dashboard_service = templatefile(
    "${path.module}/templates/dashboard.service.tpl",
    {
      service_name  = var.dashboard_service_name
      app_user      = var.dashboard_app_user
      app_directory = var.dashboard_app_directory
      app_port      = var.dashboard_app_port

      counting_endpoint = aws_lb.counting.dns_name
      counting_port     = var.counting_app_port
    }
  )


  counting_user_data = templatefile(
    "${path.module}/scripts/counting_user_data.sh.tpl",
    {
      bucket_name   = aws_s3_bucket.consul-demo.bucket
      app_directory = var.counting_app_directory
      app_user      = var.counting_app_user

      counting_service = local.counting_service
    }
  )

  dashboard_user_data = templatefile(
    "${path.module}/scripts/dashboard_user_data.sh.tpl",
    {
      bucket_name   = aws_s3_bucket.consul-demo.bucket
      app_directory = var.dashboard_app_directory
      app_user      = var.dashboard_app_user

      dashboard_service = local.dashboard_service
    }
  )


  project_name = "consul-demo"

  name_prefix = "${local.project_name}-${var.environment}"

  common_tags = {
    Project     = local.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}