resource "aws_instance" "webserver" {
   ami = "ami-0aa7d40eeae50c9a9"
   instance_type = "t2.micro"
   tags = {
      Name = "webserver"
      Description = "Nginx on ubuntu"
   }

   provisioner "remote-exec" {
      inline = [ "sudo apt update",
                 "sudo apt install nginx -y",
                 "systemctl enable nginx",
                 "systemctl start nginx",
               ]
   }

   connection {
      type = "ssh"
      host = self.public_ip
      user = "ubuntu"
      private_key = "webserver"
   }

   key_name = "webserver"
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