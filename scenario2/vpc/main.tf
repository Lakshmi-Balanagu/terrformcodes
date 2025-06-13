data "aws_availability_zones" "available" {}

resource "aws_vpc" "sc2_vpc"{
    cidr_block = var.vpc_cidr
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    instance_tenancy = "default"
    tags = {
        Name = var.vpc_name
    }
}

resource "aws_subnet" "sc2_public" {
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.sc2_vpc.id
    cidr_block = var.public_subnet_cidrs[count.index]
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.available.names[count.index]
    tags = {
        Name = "${var.vpc_name}_public_subnet_${count.index}"
    }

}
resource "aws_subnet" "sc2_private"{
    count = length(var.private_subnet_cidrs)
    vpc_id = aws_vpc.sc2_vpc.id
    cidr_block = var.private_subnet_cidrs[count.index]
    availability_zone = data.aws_availability_zones.available.names[count.index]
    tags = {
        Name = "${var.vpc_name}_private_subnet_${count.index}"
    }

}

resource "aws_internet_gateway" "sc2_IGW" {
    count = length(var.public_subnet_cidrs) > 0 ? 1 : 0
    vpc_id = aws_vpc.sc2_vpc.id
    tags = {
        Name = "${var.vpc_name}_IGW"
    }

}

resource "aws_route_table" "public_rt"{
    vpc_id = aws_vpc.sc2_vpc.id
    count  = length(var.public_subnet_cidrs) > 0 ? 1 : 0
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.sc2_IGW[count.index].id
    }
    tags = {
         Name = "${var.vpc_name}_public_route_table"
    }
}

resource "aws_route_table_association" "public_assoc" {
    count = length(var.public_subnet_cidrs)
    subnet_id = aws_subnet.sc2_public[count.index].id
    route_table_id = aws_route_table.public_rt[0].id

}

resource "aws_eip" "eip"{
    count = var.enable_nat_gateway ? 1 :0
    tags = {
        Name = "${var.vpc_name}_NAT_EIP"
    }
    
}

resource "aws_nat_gateway" "nat"{
    count   = var.enable_nat_gateway ? 1 : 0
    subnet_id = aws_subnet.sc2_public[0].id
    allocation_id = aws_eip.eip[0].id
    depends_on  = [aws_internet_gateway.sc2_IGW]
    tags = {
        Name = "${var.vpc_name}_NAT_Gateway"
    }
}

resource "aws_route_table" "private_rt"{
    count = var.enable_nat_gateway ? 1 : 0
    vpc_id = aws_vpc.sc2_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat[0].id
    }
    tags = {
      Name = "${var.vpc_name}_private_route_table"
    }


}
resource "aws_route_table_association" "private_assoc"{
    count = length(var.private_subnet_cidrs)
    subnet_id = aws_subnet.sc2_private[count.index].id
    route_table_id = aws_route_table.private_rt[0].id

}
