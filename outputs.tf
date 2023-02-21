output "testing_linuxAMI" {
  value = nonsensitive(data.aws_ssm_parameter.linuxAmi.value)
}
