

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
