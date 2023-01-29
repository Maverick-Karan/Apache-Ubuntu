provider "aws" {
   region = "us-east-1"
   access_key = "${{ secrets.AWS_ACCESS_KEY_ID }}"
   secret_key = "${{ secrets.AWS_SECRET_ACCESS_KEY }}"
}

resource "aws_s3_bucket" "bucket" {
   bucket = "test211293"
   tags = {
      description = "Testing"
   }
}


resource "aws_s3_bucket_object" "object" {
  bucket = "test211293"
  key    = "buddha.jpg"
  source = "./buddha.jpg"
  etag = filemd5("./buddha.jpg")
}
