variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
  }

variable "public_subnet_cidr" {
    type = list
}

variable "private_subnet_cidr" {
    type = list
}

variable "database_subnet_cidr" {
    type = list
}


variable "project" {
  type = string
}

variable "environment" {
    type = string
  
}


variable "public_subnet_tags" {
    type = map
    default = {}
}



variable "private_subnet_tags" {
    type = map
    default = {}
}

variable "database_subnet_tags" {
    type = map
    default = {}
}
# if i want to write common tags by using var.project and var.environemt....variables wont work here
# we should use locals if we want to use variables inside other varaibles
# so check locals.tf file

# variable "common_Tags" {
#     type = map
#     default = {
#         project = var.project         -> it wont work like this
#         environment = var.environment
#     }
  
# }

#we can ask user if they needs peering
#based on the user response we can write condition in peering.tf so that it will run only if user set's 
# it's value to true

variable "is_peering_required" {
    default = false
}

variable "peering_tags" {
    type = map
    default = {}
}
