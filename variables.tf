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

# here common tags like project name, environment details i want to get from user and then write common tags 
#based on that

#-> if we just declare a variable with it's type then it makes variable mandatory to provide value. so user should definitely provide a value otherwise during execution it will ask in prompt for value.


variable "project" {
  type = string
}

variable "environment" {
    type = string
  
}


# if we want to give a choice which is not mandatory . it's user wish to add tags or not.
# in such cases,
# 	along with type, we need to add default value also. which i declared in above example.
# 	default ={} -> this declaration will not ask value from user mandatorily. it will take value if user provides, otherwise it wont rise any error.

variable "public_subnet_tags" {
    type = map
    default = {}
}

#here we are giving an option to user to add tags if they want. and it is not mandatory.

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