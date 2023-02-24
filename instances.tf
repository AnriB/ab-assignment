# finds the Linux AMI using SSM Parameter enpoint in us-east-1 region
data "aws_ssm_parameter" "linuxAmi" {
  provider = aws.default-region
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# uses key pair for loggign into EC2 us-east-1
resource "aws_key_pair" "control-key" {
  provider   = aws.default-region
  key_name   = "master-key"
  public_key = file("~/.ssh/id_rsa.pub")
}


# Create the EC2 instance running the K8S control plane
resource "aws_instance" "control-plane" {
  provider                    = aws.default-region
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.control-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.control_plane_sg.id]
  subnet_id                   = aws_subnet.subnet_1.id
  tags = {
    Name = "control_plane_instance"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sleep 180",
      "sudo systemctl restart polkit",
      "sudo echo '${self.private_ip} ${aws_instance.control-plane.tags.Name}' >> /etc/hosts",
      "sudo hostnamectl set-hostname ${aws_instance.control-plane.tags.Name}"
    ]
    connection {
      type = "ssh"
      host = self.public_ip
      user = "ec2-user"
      private_key = file("~/.ssh/id_rsa")

      timeout = "5m"
    }
  }

  provisioner "local-exec" {
    command = <<EOF
  aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region} --instance-ids ${self.id}
  ansible-playbook --extra-vars 'passing_hosts=tag_Name_${self.tags.Name}' ansible_playbooks/control-plane.yml -v > /var/log/control-plane.log
  EOF
  }
}

# Creates EC2 instances running the k8s workers
resource "aws_instance" "workers" {
  provider                    = aws.default-region
  count                       = var.worker-count
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.control-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.workers_sg.id]
  subnet_id                   = aws_subnet.subnet_1.id
  tags = {
    Name = join("_", ["worker_instance", count.index + 1])
  }

  depends_on = [aws_instance.control-plane]

  provisioner "remote-exec" {
    inline = [
      "sudo sleep 180",
      "sudo systemctl restart polkit",
      "sudo echo '${self.private_ip} ${aws_instance.workers[count.index + 1].tags.Name}' >> /etc/hosts",
      "sudo hostnamectl set-hostname ${aws_instance.workers[count.index + 1].tags.Name}"
    ]
    connection {
      type = "ssh"
      host = self.public_ip
      user = "ec2-user"
      private_key = file("~/.ssh/id_rsa")

      timeout = "5m"
    }
  }

  provisioner "local-exec" {
    command = <<EOF
  aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region} --instance-ids ${self.id}
  ansible-playbook --extra-vars 'passing_hosts=tag_Name_${self.tags.Name}' ansible_playbooks/workers.yml -v > /var/log/worker.log
  EOF
  }
}
