variable "profile" {
  type    = string
  default = "default"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

# EC2 instance type to create
variable "instance-type" {
  type    = string
  default = "t3.small"
}

# Number of K8S workers
variable "worker-count" {
  type    = number
  default = 1
}