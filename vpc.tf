resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = merge(local.common_Tags,
  {
    Name = "${var.project}-${var.environment}"
  }
  )
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_Tags,{
    Name = "${var.project}-IGW"
  }
  )
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  

  cidr_block = var.public_subnet_cidr[count.index]

  availability_zone = local.availble_zone[count.index]

 map_public_ip_on_launch = true

  tags = merge( var.public_subnet_tags, local.common_Tags,{
    Name = "${var.project}-public-${local.availble_zone[count.index]}"
  })
  }




resource "aws_subnet" "private" {
  
  count = length(var.private_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr[count.index]

  availability_zone = local.availble_zone[count.index]

  tags = merge( var.private_subnet_tags,local.common_Tags,{
    Name = "${var.project}-private-${local.availble_zone[count.index]}"
  })
}

resource "aws_subnet" "database" {
  vpc_id     = aws_vpc.main.id
  count = length(var.database_subnet_cidr)

  cidr_block = var.database_subnet_cidr[count.index]

  availability_zone = local.availble_zone[count.index]

  tags = merge( var.database_subnet_tags,local.common_Tags,{
    Name = "${var.project}-database-${local.availble_zone[count.index]}"
  })
}

resource "aws_eip" "ip" {
  domain   = "vpc"

tags = merge( local.common_Tags,{
    Name = "${var.project}-eip"
  })

}

resource "aws_nat_gateway" "roboshop-NAT" {
  allocation_id = aws_eip.ip.id  #this will be our elastic ip id
  subnet_id     = aws_subnet.public[0].id # in which subnet we want our nat gateway to be created. As we have 2 public subents in 2 regiosn. i want my subnet to be created in 1st region. so i gave index 0

 tags = merge( local.common_Tags,{
    Name = "${var.project}-NAT"
  })

  depends_on = [aws_internet_gateway.IGW]


}
	
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  
 tags = merge( local.common_Tags,{
    Name = "${var.project}-public-route-table"
  })
}

resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.public_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.IGW.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

 tags = merge( local.common_Tags,{
    Name = "${var.project}-private-route-table"
  })
}

resource "aws_route" "private_route" {
  route_table_id            = aws_route_table.private_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.roboshop-NAT.id
}

resource "aws_route_table" "database_route_table" {
  vpc_id = aws_vpc.main.id

 tags = merge( local.common_Tags,{
    Name = "${var.project}-database-route-table"
  })
}

resource "aws_route" "database_route" {
  route_table_id            = aws_route_table.database_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.roboshop-NAT.id
}

resource "aws_route_table_association" "public" {
    count = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private" {
    count = length(var.private_subnet_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "database" {
    count = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database_route_table.id
}

