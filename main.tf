resource "aws_instance" "webserver" {
   ami = "ami-0aa7d40eeae50c9a9"
   instance_type = "t2.micro"
   tags = {
      Name = "webserver"
      Description = "Nginx on ubuntu"
   }

   user_data = <<-EOF
               #!/bin/bash
               sudo apt update
               sudo apt install nginx -y
               systemctl enable nginx
               systemctl start nginx
               EOF
   key_name = "webserver.pem"
   vpc_security_group_ids = [aws_security_group.ssh-access.id]
}





resource "aws_security_group" "ssh-access" {
   name = "webserverSG"
   description = "allow SSH"
   ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
   }
}

output publicip {
   value = aws_instance.webserver.public_ip
}