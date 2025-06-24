resource "aws_vpc_peering_connection" "peer" {
  count = var.is_peering_required ? 1:0 # this condition ensures this code block runs only if user set's is_peering_required value to true
  peer_vpc_id   = data.aws_vpc.default.id #destination vpc id (so we are querying provider to gove default vpc id and using it here.)
  vpc_id        = aws_vpc.main.id # requester vpc id
  auto_accept   = true #if we are connection within the same aws and same region then it will auto approve peer request

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

 tags = merge( var.peering_tags, local.common_Tags,{
    Name = "${var.project}-peering"
  }
  )

}

# once we established peer connection then we can add routes from roboshop public subnet cidr to default vpc cidr 
# and vice versa

resource "aws_route" "public_peer" {
  count = var.is_peering_required ? 1:0
  route_table_id            = aws_route_table.public_route_table.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer[count.index].id
}

resource "aws_route" "default_peer" {
  count = var.is_peering_required ? 1:0
  route_table_id            = data.aws_route_table.main.id
  destination_cidr_block    = aws_vpc.main.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer[count.index].id
}