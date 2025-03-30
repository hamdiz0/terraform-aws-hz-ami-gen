output "custom_ami_id" {
  value = aws_ami_from_instance.custom_ami.id
  description = "The id of the custom ami"
}