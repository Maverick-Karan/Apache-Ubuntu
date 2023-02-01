#Create EC2, install Apache, add Index file, add SSH security group, add Public access Security group, Output PublicIP of EC2

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
#Create bucket for S3 bucket ad DynamoDB for S3 State backend

resource "aws_s3_bucket" "state_bucket" {
  bucket = var.state_bucket

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



#####################################################################################################################
#Create S3 bucket, enable static website, attach public policy, upload objects & index.html, output static website URL
resource "aws_s3_bucket" "bucket" {
   bucket = var.web_bucket
   tags = {
      description = "Testing"
   }
}

resource "aws_s3_bucket_website_configuration" "website-config" {
  bucket = aws_s3_bucket.bucket.bucket
  index_document {
       suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "public_read_access" {
  bucket = aws_s3_bucket.bucket.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
	   "Principal": "*",
      "Action": [ "s3:*" ],
      "Resource": [
        "arn:aws:s3:::test21121007/*"
      ]
    }
  ]
}
EOF
}


resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.bucket.id
  key    = "buddha.jpg"
  source = "./buddha.jpg"
  content_type = "image/jpeg"
  etag = filemd5("./buddha.jpg")

  depends_on = [aws_s3_bucket.bucket]
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.bucket.id
  key    = "index.html"
  source = "./index.html"
  content_type = "text/html"
  etag = filemd5("./index.html")

  depends_on = [aws_s3_bucket.bucket]
}

output static-website {
   value = "http://${aws_s3_bucket.bucket.id}.s3-website-${var.region}.amazonaws.com"
}