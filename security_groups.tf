# Security group to allow SSH Access/yum operation and the neccesary ports for kubernetes to operate to the EC2 control plane node
resource "aws_security_group" "control_plane_sg" {
  provider    = aws.default-region
  name_prefix = "control_plane_sg"
  vpc_id      = aws_vpc.vpc_default.id

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow ping only within the subnet

  ingress {
    protocol = "icmp"
    cidr_blocks = ["10.0.1.0/24"]
    icmp_type = 8
    icmp_code = -1
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["10.0.1.0/24"]
  }

  # Kubernetes requirements per > https://kubernetes.io/docs/reference/networking/ports-and-protocols/

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  ingress {
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  ingress {
    from_port   = 10259
    to_port     = 10259
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  ingress {
    from_port   = 10257
    to_port     = 10257
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  # The following ports are opened for YUM    
  egress {
    from_port   = 21
    to_port     = 21
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 873
    to_port     = 873
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group to allow SSH Access/yum operation and the neccesary ports for kubernetes to operate on the Worker ndoes
resource "aws_security_group" "workers_sg" {
  provider    = aws.default-region
  name_prefix = "workers_sg"
  vpc_id      = aws_vpc.vpc_default.id

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow ping only within the subnet

  ingress {
    protocol = "icmp"
    cidr_blocks = ["10.0.1.0/24"]
    icmp_type = 8
    icmp_code = -1
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["10.0.1.0/24"]
  }

  # Kubernetes requirements per > https://kubernetes.io/docs/reference/networking/ports-and-protocols/
  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  # The following ports are opened for YUM
  egress {
    from_port   = 21
    to_port     = 21
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 873
    to_port     = 873
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
