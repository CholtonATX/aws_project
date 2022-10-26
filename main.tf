resource "aws_vpc" "aws_test" {
  cidr_block           = "10.252.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "aws_test"
  }
}

resource "aws_subnet" "aws_test_subnet" {
  vpc_id                  = aws_vpc.aws_test.id
  cidr_block              = "10.252.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2b"

  tags = {
    Name = "aws_test-public"
  }
}

resource "aws_internet_gateway" "aws_test_igw" {
  vpc_id = aws_vpc.aws_test.id

  tags = {
    Name = "aws_test_igw"
  }
}

resource "aws_route_table" "aws_test_rt" {
  vpc_id = aws_vpc.aws_test.id

  tags = {
    Name = "aws_test_public_rt"
  }
}

resource "aws_route" "aws_test_default_rt" {
  route_table_id         = aws_route_table.aws_test_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.aws_test_igw.id
}

resource "aws_route_table_association" "aws_test_rt_assoc" {
  subnet_id      = aws_subnet.aws_test_subnet.id
  route_table_id = aws_route_table.aws_test_rt.id
}

resource "aws_security_group" "aws_test_sg" {
  name        = "aws_test_sg"
  description = "aws_test security group"
  vpc_id      = aws_vpc.aws_test.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["24.227.217.188/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "aws_test_key" {
  key_name   = "aws_test_key"
  public_key = file("~/.ssh/aws_test_key.pub")
}

