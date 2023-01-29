provider "aws" {
   region = "us-east-1"
   access_key = "AKIA3K72NPHY6ZZCJNNO"
   secret_key = "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"
}

resource "aws_s3_bucket" "bucket" {
   bucket = "test211293"
   tags = {
      description = "Testing"
   }
}

resource "aws_s3_object" "object" {
  bucket = "test211293"
  key    = "buddha.jpg"
  source = "C:\\Users\\Karan\\Pictures\\buddha.jpg"
  etag = filemd5("C:\\Users\\Karan\\Pictures\\buddha.jpg")
}