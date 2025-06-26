# after executing vpc module , this vpc will be created in aws along with that vpc_id will be sent as output
# this output should be captured and stored in ssm parameter store while creating vpc .

#capturing the output and storing it in ssm parameter store is the responsibilty of employee who is creating this
# vpc instance


output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "database_subnet_ids" {
  value = aws_subnet.database[*].id
}