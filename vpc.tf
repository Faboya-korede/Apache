resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Altschool-VPC"
 }
}


# create subnets
resource "aws_subnet" "public-1-subnet" {
 vpc_id     = aws_vpc.main.id
 cidr_block = var.public1_cidr
 availability_zone = "us-east-1b"
 tags = {
  Name = "Public Subnet-1"
 }
}

resource "aws_subnet" "public-2-subnet"{
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public2_cidr

  tags = {
    Name = "public subnet-2"
  }
}


resource "aws_subnet" "public-3-subnet"{
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "public subnet-3"
  }
}


resource "aws_internet_gateway" "altschool_ig" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Altschool Internet Gateway"
  }
}


# create route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.altschool_ig.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.altschool_ig.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

# route table association
resource "aws_route_table_association" "pub1" {
  subnet_id      = aws_subnet.public-1-subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "pub2" {
  subnet_id      = aws_subnet.public-2-subnet.id
  route_table_id = aws_route_table.public_rt.id
}



# Aws security group
resource "aws_security_group" "web_sg" {
  name   = "HTTP and SSH"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}
