# hz-ami-gen

##### This module uses the `Terraform Provisionars` to execute the a provided script form the inputs on an instance wich is based on the specified `AMI`.

##### The module requires an `ssh key pair` to be created both the private and public key paths must provided in the inputs.

##### The script path also needs to be provided to create the new `AMI`.

#### Usage :
##### generate an ssh key pair :
```sh
mkdir key-pair ; cd key-pair
ssh-keygen -f ssh-key
```

##### deploy the module :
```hcl
module "ami-gen" {
  source = "hamdiz0/hz-ami-gen/aws"

  public_ssh_key_path = "./key-pair/ssh-key.pub"
  private_ssh_key_path = "./key-pair/ssh-key"
  script_path = "./scripts/script.sh"

  public_subnet_id = aws_subnet.public_subnet.id

  base_ami = "ami-0359cb6c0c97c6607" # debian 12 ami
  ami_default_user = "admin"         # default user name for the debian ami is "admin"
  custom_ami_name = "k8s_debian_ami"

  delete_resources = true
}
```

