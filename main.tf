resource "aws_instance" "webserver" {
   ami = "ami-0aa7d40eeae50c9a9"
   instance_type = "t2.micro"
   tags = {
      Name = "webserver"
      Description = "Apachee on ubuntu"
   }

   user_data = <<-EOF
               #!/bin/bash
               sudo yum update -y
               sudo yum install -y httpd
               sudo systemctl enable httpd
               sudo service httpd start 
               EOF

   key_name = "webserver"
   vpc_security_group_ids = [aws_security_group.ssh-access.id, aws_security_group.public_access.id]
   
}


resource "aws_security_group" "ssh-access" {
   name = "SSH-SG"
   description = "allow SSH"
   ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
   }
}

resource "aws_security_group" "public_access" {
   name = "public-SG"
   description = "open to www"
   ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
   }

   egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
   }
}



output publicip {
   value = aws_instance.webserver.public_ip
}