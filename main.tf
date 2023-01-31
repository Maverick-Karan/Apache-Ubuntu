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
               sudo echo '<h1>Welcome to Apache on Ubuntu </h1>' | sudo tee /var/www/html/index.html
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

###############################################################################################################


resource "aws_s3_bucket" "state_bucket" {
  bucket = var.name_of_s3_bucket

  tags = {
    Name= "S3Backend"
  }
}


resource "aws_dynamodb_table" "DB_lock_state" {
  name = var.dynamo_db_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name    = var.dynamo_db_table_name
    BuiltBy = "Terraform"
  }
}


###########################################################################################

terraform {
   backend "s3" {
      bucket = var.name_of_s3_bucket
      key = "backend/terraform.tfstate"
      region = var.region
      dynamodb_table = "state-locking" 
   }
}



##############################################################################################

resource "aws_s3_bucket" "bucket" {
   bucket = "test2112"
   website {
      index_document = "index.html"
   }
   tags = {
      description = "Testing"
   }
}

resource "aws_s3_object" "object" {
  bucket = "test2112"
  key    = "buddha.jpg"
  source = "./buddha.jpg"
  etag = filemd5("./buddha.jpg")
}

resource "aws_s3_object" "index" {
  bucket = "test2112"
  key    = "index.html"
  source = "./index.html"
  etag = filemd5("./buddha.jpg")
}


