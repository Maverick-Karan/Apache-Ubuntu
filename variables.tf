variable "state_bucket" {
   default = "test211293"
}

variable "web_bucket" {
   default = "test21121007"
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
