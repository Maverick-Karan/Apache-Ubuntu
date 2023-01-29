provider "aws" {
   region = "us-east-1"
}

resource "aws_s3_bucket" "bucket" {
   bucket = "testdynamoDB1007"
   tags = {
      description = "Testing"
   }
}