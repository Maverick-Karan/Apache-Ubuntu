terraform {
   backend "s3" {
      bucket = "testing211293"
      key = "./terraform.tfstate"
      region = "us-east-1"
      dynamodb_table = "state-locking" 
   }
}