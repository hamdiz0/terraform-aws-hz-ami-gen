# create a key for ssh connection
resource "aws_key_pair" "key" {
  key_name   = "ssh-key"
  public_key = file(var.public_ssh_key_path)
}

# create an isntance and execute the script
resource "aws_instance" "custom_ami_instance" {
  ami                         = var.base_ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.custom_ami_sg.id]
  subnet_id                   = var.public_subnet_id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.key.key_name

  # connect to the instance via ssh
  connection {
    type        = "ssh"
    user        = var.ami_default_user
    private_key = file(var.private_ssh_key_path)
    host        = aws_instance.custom_ami_instance.public_ip
  }

  # copy the scripts to the instance
  provisioner "file" {
    source      = var.script_path
    destination = "/home/${var.ami_default_user}/${basename(var.script_path)}"
  }

  # execute the scripts
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.ami_default_user}/${basename(var.script_path)}",
      "sudo bash /home/${var.ami_default_user}/${basename(var.script_path)}",
    ]
  }
}

# create an ami
resource "aws_ami_from_instance" "custom_ami" {
  name = var.custom_ami_name
  source_instance_id = aws_instance.custom_ami_instance.id
  snapshot_without_reboot = true
}

# use aws cli to terminate the resources
resource "null_resource" "terminate_ami_instance" {
  count = var.delete_resources ? 1 : 0
  provisioner "local-exec" {
    command = <<EOT
      aws ec2 terminate-instances --instance-ids ${aws_instance.custom_ami_instance.id}
      aws ec2 wait instance-terminated --instance-ids ${aws_instance.custom_ami_instance.id}
      aws ec2 delete-security-group --group-id ${aws_security_group.custom_ami_sg.id}
      aws ec2 delete-key-pair --key-name ${aws_key_pair.key.key_name}
    EOT
  }
  depends_on = [aws_ami_from_instance.custom_ami]
}