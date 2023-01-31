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
               sudo echo '<h1>Welcome to StackSimplify - APP-1</h1>' | sudo tee /var/www/html/index.html
               sudo mkdir /var/www/html/app1
               sudo echo '<!DOCTYPE html> <html> <body style="background-color:rgb(250, 210, 210);"> <h1>Welcome to Stack Simplify - APP-1</h1> <p>Terraform Demo</p> <p>Application Version: V1</p> </body></html>' | sudo tee /var/www/html/app1/index.html
               sudo curl http://169.254.169.254/latest/dynamic/instance-identity/document -o /var/www/html/app1/metadata.html
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