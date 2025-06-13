provider "aws"{
    region = var.region
}

resource "aws_vpc" "sc2_vpc"{
    cidr_block = var.vpc_cidr
    enable_dns_support = "tru"
    enable_dns_hostnames = "true"
    instance_tenancy = "default"
    tags = {
        Name = var.vpc_name
    }
}

resource "aws_subnet" "sc2_public" {
    count = lengt(var.public_subnet_cidrs)
    vpc_id = aws_vpc.sc2_vpc.id
    cidr_block = var.public_subnet_cidrs[count.index]
    map_public_ip_on_launch = true
    tags = {
        Name = "${aws_vpc.sc2_vpc.tags["Name"]}_public_subnet_${count.index}"
    }

}
resource "aws_subenet" "sc2_private"{
    count = length(var.private_subnet_cidrs)
    vpc_id = aws_vpc.sc2_vpc
    cidr_blocks = var.private_subnet_cidrs[count.index]
    tags = {
        Name = "${aws_vpc.sc2_vpc.tags["NAME"]}_private_subnet_${count.index}"
    }

}
resource "aws_internet_gateway" "sc2_IGW" {
    vpc_id = aws_vpc.sc2_vpc.id
    tags = {
        Name = "${aws_vpc.sc2_vpc.tags["Name"]}_IGW"
    }

}

resource "aws_route_table" "public_rt"{
    vpc_id = aws_vpc.sc2_vpc.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.sc2_IGW.id
    }
    tags = {
         Name = "${aws_vpc.sc2_vpc.tags["Name"]}_public_route_table"
    }
}
resource "aws_route_table_association" "public_assoc" {
    count = length(var.public_subnet_cidrs)
    subnet_id = aws_subnet.sc2_public[count.index].id
    route_table_id = aws_route_table.public_rt.id

}
resource "aws_eip" "eip"{
    count = length(var.private_subnet_cidrs) > 0 ? 1 :0
    vpc = true
    tags = {
        Name = "${aws_vpc.sc2_vpc.tags["Name"]}_NAT_EIP"
    }
    
}
resource "aws_nat_gateway" "nat"{


}
resource "aws_route_table" "private_rt"{

}
resource "aws_route_table_association" "private_assoc"{

}
