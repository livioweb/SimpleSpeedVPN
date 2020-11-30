resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "Locust VPC"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Locust IGW"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public
  availability_zone = "${var.region}a"

  tags = {
    Name = "Public 1a"
  }
}

resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Locust Public"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rt_public.id
}
