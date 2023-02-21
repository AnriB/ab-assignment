# Security group to allow SSH Access to the EC2 instances
resource "aws_security_group" "all_instances" {
  provider    = aws.default-region
  name_prefix = "all_instances"
  vpc_id      = aws_vpc.vpc_default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
