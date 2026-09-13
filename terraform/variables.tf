variable "aws_region" {
  description = "The region where the resources are created"
  type        = string
}

variable "vpc_cidr" {
  description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
  type        = string
}
variable "environment" {
  description = "target environment"
  type        = string
}
variable "public_subnet_prefix" {
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "private_subnet_prefix" {
  type = map(object({
    cidr = string
    type = string
    az   = string
  }))
}

variable "instance_type" {
  description = "Specifies the AWS instance type."
  default     = "t3.micro"
}

variable "counting_service_name" {
  type = string
}

variable "counting_app_user" {
  type = string
}

variable "counting_app_directory" {
  type = string
}

variable "counting_app_port" {
  type = number
}

variable "dashboard_service_name" {
  type = string
}

variable "dashboard_app_user" {
  type = string
}

variable "dashboard_app_directory" {
  type = string
}

variable "dashboard_app_port" {
  type = number
}