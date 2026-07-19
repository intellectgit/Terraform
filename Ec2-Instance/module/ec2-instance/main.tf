

resource "aws_instance" "jfrog" {
  ami = var.ami_value
  instance_type = var.instance_type_value
  key_name = var.key_name-value
  vpc_security_group_ids = [aws_security_group.mysg.id]
  tags = {
    Name = "Jenkins-server-install"
  }

    }

resource "aws_security_group" "mysg" {
    name = "launch jfrog"
    description = "Allow ssh and launch jfrog server"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
  egress {
    from_port = 0
    to_port = 0 
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

    