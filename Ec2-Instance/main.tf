
provider "aws" {
  region = "us-east-1"
}

module "ec2-instance" {
   source = "./module/ec2-instance"
   ami_value = "ami-01edba92f9036f76e"
   instance_type_value = "t2.micro"
   key_name-value = "connect"
}

# using module no need of create the resource. 
# the module will fetch the source code from the path which we provided to hte source.
#just deleted terraform.tfvar to avoid the duplicate values 
# I have hard coded all my values which are required for my ec2 instance. 
# here I used variable key instead of direct terraform keys.


