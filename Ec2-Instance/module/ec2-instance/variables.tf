variable "ami_value" {
    description = "use linux flavour"
    default = "default go with linux"
  
}

variable "instance_type_value" {
    description = "instance of the type"
    default = "by default go with t2.micro"
  
}

variable "key_name-value" {
    description = "key pair for the instance"
    default = "required key pair to connect"
  
}
