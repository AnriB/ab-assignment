# Creates a VPC in default region (us-east-1)
resource "aws_vpc" "vpc_default" {
  provider   = aws.default-region
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc_default_cluster"
  }

}


# Get all the available avaliability zones in VPC for default region (us-east-1)
data "aws_availability_zones" "azs" {
  provider = aws.default-region
  state    = "available"
}

# Create subnet #1
resource "aws_subnet" "subnet_1" {
  provider          = aws.default-region
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc_default.id
  cidr_block        = "10.0.1.0/24"
}


# Create subnet #2
#resource "aws_subnet" "subnet_2" {
#  provider          = aws.default-region
#  vpc_id            = aws_vpc.vpc_default.id
#  availability_zone = element(data.aws_availability_zones.azs.names, 1)
#  cidr_block        = "10.0.2.0/24"
#}


# Creates IGW in default region
resource "aws_internet_gateway" "igw" {
  provider = aws.default-region
  vpc_id   = aws_vpc.vpc_default.id
}

# Create route table in default region
resource "aws_route_table" "internet_route" {
  provider = aws.default-region
  vpc_id   = aws_vpc.vpc_default.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

#Overwrite default route table of VPC with our route table entries
resource "aws_main_route_table_association" "set-worker-default-rt-assoc" {
  provider       = aws.default-region
  vpc_id         = aws_vpc.vpc_default.id
  route_table_id = aws_route_table.internet_route.id
}
