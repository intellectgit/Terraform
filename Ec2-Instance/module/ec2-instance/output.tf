    output "public-ip-address" {
        value = aws_instance.jfrog.public_ip
      
    }

    output "instance-tag" {
        value = aws_instance.jfrog.tags
      
    }

    output "key-pair-name" {
        value = aws_instance.jfrog.key_name
      
    }

   output "security-group-id" {
       value = aws_instance.jfrog.security_groups
     
   }
