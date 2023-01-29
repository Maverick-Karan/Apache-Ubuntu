provider "aws" {
   region = "us-east-1"
}




resource "aws_s3_object" "object" {
  bucket = "test211293"
  key    = "buddha.jpg"
  source = "./buddha.jpg"
  #etag = filemd5("./buddha.jpg")
}
