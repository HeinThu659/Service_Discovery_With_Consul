vpc_cidr    = "10.0.0.0/16"
aws_region  = "ap-northeast-1"
environment = "dev"

counting_service_name  = "Counting Service"
counting_app_user      = "counting"
counting_app_directory = "/opt/counting-service"
counting_app_port      = 7777

dashboard_service_name  = "Dashboard Service"
dashboard_app_user      = "dashboard"
dashboard_app_directory = "/opt/dashboard-service"
dashboard_app_port      = 8888

public_subnet_prefix = {
  public_a_alb = {
    cidr = "10.0.1.0/24"
    az   = "ap-northeast-1a"
  }

  public_c_alb = {
    cidr = "10.0.2.0/24"
    az   = "ap-northeast-1c"
  }
}

private_subnet_prefix = {
  private_a_dashboard = {
    cidr = "10.0.3.0/24"
    type = "dashboard"
    az   = "ap-northeast-1a"
  }

  private_c_dashboard = {
    cidr = "10.0.4.0/24"
    type = "dashboard"
    az   = "ap-northeast-1c"
  }

  private_a_counting_alb = {
    cidr = "10.0.5.0/24"
    type = "counting-alb"
    az   = "ap-northeast-1a"
  }

  private_c_counting_alb = {
    cidr = "10.0.6.0/24"
    type = "counting-alb"
    az   = "ap-northeast-1c"
  }

  private_a_counting = {
    cidr = "10.0.7.0/24"
    type = "counting"
    az   = "ap-northeast-1a"
  }

  private_c_counting = {
    cidr = "10.0.8.0/24"
    type = "counting"
    az   = "ap-northeast-1c"
  }
}