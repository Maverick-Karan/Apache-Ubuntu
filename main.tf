provider "aws" {
   region = "us-east-1"
}

resource "aws_s3_bucket" "bucket" {
   bucket = "testing211293"
   tags = {
      description = "Testing"
   }
}