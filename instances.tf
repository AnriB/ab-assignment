# finds the Linux AMI using SSM Parameter enpoint in us-east-1 region
data "aws_ssm_parameter" "linuxAmi" {
  provider = aws.default-region
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}
