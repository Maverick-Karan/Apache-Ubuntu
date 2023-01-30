terraform {
   backend "s3" {
      bucket = "test211293"
      key = "backend/terraform.tfstate"
      region = "us-east-1"
      dynamodb_table = "state-locking" 
      encrypt = true
   }
}