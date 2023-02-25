
# ab-assignment

Deploys a Kubernetes cluster on AWS using Terraform + Ansible.


## Requirements
The following binaries/tools are required to be installed on a Linux machine/VM:
- Terraform binary >= v1.3.8
- Ansible >= v2.13
- aws-cli (IAM user that has all permissions on ec2, acm, elasticloadbalancing, ssm, s3)
- python >= 3.6
- boto3 >= 1.18.0
- botocore >= 1.21.0
- RSA 2048-bit key pair placed under ~/.ssh

## Authors

- [@AnriB](https://www.github.com/octokatherine)