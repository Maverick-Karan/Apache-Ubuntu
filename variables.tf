variable "name_of_s3_bucket" {
   default = "test211293"
}

variable "dynamo_db_table_name" {
   default = "state-locking"
}

variable "key" {
   default = "backend/terraform.tfstate"
}

variable "region" {
   default = "us-east-1"
}
