output "control-plane-IP" {
  value = aws_instance.control-plane.public_ip
}

output "worker-IP" {
  value = {
    for instance in aws_instance.workers :
    instance.id => instance.public_ip
  }
}
