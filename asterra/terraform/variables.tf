variable "aws_region" {
  default = "us-east-2"
}

variable "project_name" {
  default = "astera-devops"
}

variable "db_username" {
  default = "asterauser"
}

variable "db_password" {
  default    = "RDS database password"
  sensitive = true
}

variable "db_name" {
  default = "astera_db"
}

variable "allowed_rdp_ip" {
  description = "CIDR block allowed to access RDP"
  # כתובת חוקית, ניתן לשנות לפי הצורך
  default = "0.0.0.0/0"
}

variable "iac_storage_bucket" {
  default = "astera-iac-storage"
}
