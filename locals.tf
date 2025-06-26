locals {
  common_Tags = {
    Project = var.project
    Environment = var.environment
    Terraform = true

  }
  availble_zone =   slice(data.aws_availability_zones.available.names, 0, 2)

  
}