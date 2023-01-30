resource "aws_instance" "webserver" {
   ami = "ami-0aa7d40eeae50c9a9"
   instance_type = "t2.micro"
   tags = {
      name = "webserver"
      description = "Nginx on ubuntu"
   }

   user_data = <<-EOF
               #!/bin/bash
               sudo apt update
               sudo apt install nginx -y
               systemctl enable nginx
               systemctl start nginx
               EOF
}