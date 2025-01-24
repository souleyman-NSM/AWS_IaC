# provider block
provider "aws" {
  region     = "us-east-1"
  access_key  = ""
  secret_key  = ""
}

# Create the VPC
resource "aws_vpc" "appstream2" {
  cidr_block = "10.0.0.0/20"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "AppStream2 VPC"
  }
}

# Create the public subnet
resource "aws_subnet" "appstream2_public" {
  vpc_id            = aws_vpc.appstream2.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "AppStream2 Public Subnet"
  }
}

# Create the private subnet 1
resource "aws_subnet" "appstream2_private_1" {
  vpc_id            = aws_vpc.appstream2.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "AppStream2 Private Subnet 1"
  }
}

# Create the private subnet 2
resource "aws_subnet" "appstream2_private_2" {
  vpc_id            = aws_vpc.appstream2.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "AppStream2 Private Subnet 2"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "appstream2_igw" {
  vpc_id = aws_vpc.appstream2.id
  tags = {
    Name = "AppStream2 Internet Gateway"
  }
}

# Create a Route Table for the public subnet
resource "aws_route_table" "appstream2_public_rt" {
  vpc_id = aws_vpc.appstream2.id
  tags = {
    Name = "AppStream2 Public Route Table"
  }
}

# Add a route for the public subnet to the Internet Gateway
resource "aws_route" "appstream2_public_igw_route" {
  route_table_id            = aws_route_table.appstream2_public_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.appstream2_igw.id
}

# Associate the public subnet with the public route table
resource "aws_route_table_association" "appstream2_public_rt_assoc" {
  subnet_id      = aws_subnet.appstream2_public.id
  route_table_id = aws_route_table.appstream2_public_rt.id
}

# Create an Elastic IP for the NAT gateway
resource "aws_eip" "appstream2_eip" {
  vpc = true
}

# Create a NAT Gateway in the public subnet
resource "aws_nat_gateway" "appstream2_nat" {
  allocation_id = aws_eip.appstream2_eip.id
  subnet_id     = aws_subnet.appstream2_public.id
  tags = {
    Name = "AppStream2 NAT Gateway"
  }
}

# Create a Route Table for the private subnet 1
resource "aws_route_table" "appstream2_private_1_rt" {
  vpc_id = aws_vpc.appstream2.id
  tags = {
    Name = "AppStream2 Private Route Table 1"
  }
}

# Add a reference to the NAT Gateway in the private route table 1
resource "aws_route" "appstream2_private_1_nat_gateway" {
  route_table_id         = aws_route_table.appstream2_private_1_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.appstream2_nat.id
}

# Associate private subnet 1 with the private route table 1
resource "aws_route_table_association" "appstream2_private_1_rt_assoc" {
  subnet_id      = aws_subnet.appstream2_private_1.id
  route_table_id = aws_route_table.appstream2_private_1_rt.id
}

# Create a Route Table for the private subnet 2
resource "aws_route_table" "appstream2_private_2_rt" {
  vpc_id = aws_vpc.appstream2.id
  tags = {
    Name = "AppStream2 Private Route Table 2"
  }
}

# Add a reference to the NAT Gateway in the private route table 2
resource "aws_route" "appstream2_private_2_nat_gateway" {
  route_table_id         = aws_route_table.appstream2_private_2_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.appstream2_nat.id
}

# Associate private subnet 2 with the private route table 2
resource "aws_route_table_association" "appstream2_private_2_rt_assoc" {
  subnet_id      = aws_subnet.appstream2_private_2.id
  route_table_id = aws_route_table.appstream2_private_2_rt.id
}

# Associate private route table 1 with the VPC Endpoint
resource "aws_vpc_endpoint_route_table_association" "appstream2_private_1_vpce_assoc" {
  vpc_endpoint_id    = "vpce-092aaf61efff7fe73"
  route_table_id     = aws_route_table.appstream2_private_1_rt.id
}

# Associate private route table 2 with the VPC Endpoint
resource "aws_vpc_endpoint_route_table_association" "appstream2_private_2_vpce_assoc" {
  vpc_endpoint_id    = "vpce-092aaf61efff7fe73"
  route_table_id     = aws_route_table.appstream2_private_2_rt.id
}

# Create VPC Gateway endpoint for S3
resource "aws_vpc_endpoint" "s3_gateway" {
  vpc_id            = aws_vpc.appstream2.id
  service_name      = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"
}

# Create VPC interface endpoint for S3
resource "aws_vpc_endpoint" "s3_interface" {
  vpc_id                = aws_vpc.appstream2.id
  service_name          = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type     = "Interface"
  subnet_ids            = [aws_subnet.appstream2_private_1.id, aws_subnet.appstream2_private_2.id]
  security_group_ids    = [aws_security_group.s3.id]
  private_dns_enabled   = true
}

# Create a security group
resource "aws_security_group" "s3" {
  name_prefix = "s3-endpoint-sg-"
  vpc_id      = aws_vpc.appstream2.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
}