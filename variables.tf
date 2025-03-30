variable "script_path" {
  type = string
  description = "The path to the script that will be executed on the instance."
}

variable "public_ssh_key_path" {
  type = string
  description = "The path to the public key that will be used to create the key pair."
}

variable "private_ssh_key_path" {
  type = string
  description = "The path to the private key that will be used to create the key pair."
}

variable "base_ami" {
  type = string
  description = "The base ami used to create the custom ami."
}

variable "custom_ami_name" {
  type = string
  default = "custom_ami"
  description = "The name of the custom ami."
}

variable "instance_type" {
  type = string
  default = "t2.micro"
  description = "The instance type used to create the custom ami"
}

variable "public_subnet_id" {
  type = string
  description = "The subnet id used to create the custom ami (it must provide internet access)."
}

variable "ami_default_user" {
  type = string
  description = "The default user for the ami (Debian: admin , Ubuntu: ubuntu , Amazon Linux: ec2-user)."
}

variable "delete_resources" {
  type = bool
  default = false
  description = "If true, the resources created by this module will be deleted exept the custom ami (note that this assumes that the aws cli is installed and configured)."
}