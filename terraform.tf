terraform {
   backend "s3" {
      bucket = "testdynamoDB1007"
      key = "backend/terraform.tfstate"
      region = "us-east-1"
      dynamodb_table = "state-locking" 
   }
}