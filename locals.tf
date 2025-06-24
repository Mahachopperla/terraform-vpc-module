locals {
  common_Tags = {
    Project = var.project
    Environment = var.environment
    Terraform = true

  }
  availble_zone =   data.aws_availability_zones.available.names
}