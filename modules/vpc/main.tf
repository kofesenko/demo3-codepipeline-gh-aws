# Configuration section for vpc
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = merge(
    { 
      Name = "${var.environment_name}-vpc" 
    },
    var.additional_tags
  )
}

# Configuration section for internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    { 
      Name = "${var.environment_name}-gw" 
    },
    var.additional_tags
  )
}

# Configuration section for Elastic IP used by NAT Gateway
resource "aws_eip" "nat_eip" {
  count = length(var.private_subnets)

  vpc = true
  tags = merge(
    {
      Name = format(
        "nat-${var.environment_name}",
      )
    },
    var.additional_tags
  )
}

resource "aws_nat_gateway" "nat_gateway" {
  count = length(var.private_subnets)

  allocation_id = element(aws_eip.nat_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)

  tags = merge(
    {
      Name = format("nat-${var.environment_name}-${element(var.azs, count.index)}",
      )
    },
    var.additional_tags
  )
  depends_on = [aws_internet_gateway.internet_gateway]
}

# Configuration section for Public Subnet
resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = format("public-subnet-${var.environment_name}-${element(var.azs, count.index)}",
      )
    },
    var.additional_tags
  )
}

# Configuration section for route table public subnet
resource "aws_route_table" "public_subnet" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = merge(
    {
      Name = format(
        "${var.environment_name}-public-rt",
      )
    },
    var.additional_tags
  )
}
# Configuration section for route table association on public route table
resource "aws_route_table_association" "public_subnet_rta" {
  count = length(var.public_subnets)

  route_table_id = aws_route_table.public_subnet.id
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
}

# Configuration section for private subnet
resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.azs, count.index)

  tags = merge(
    {
      Name = format("private-subnet-${var.environment_name}-${element(var.azs, count.index)}",
      )
    },
    var.additional_tags
  )
}

# Configuration section for route table private subnet
resource "aws_route_table" "private_subnet" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_nat_gateway.nat_gateway.*.id, count.index)
  }
  tags = merge(
      {
        Name = format(
          "${var.environment_name}-private-rt",
        )
      },
      var.additional_tags
    )
}
# Configuration section for route table association on private route table
resource "aws_route_table_association" "private_subnet_rta" {
  count = length(var.private_subnets)

  route_table_id = aws_route_table.private_subnet.*.id[count.index]
  subnet_id      = aws_subnet.private_subnet.*.id[count.index]
}
