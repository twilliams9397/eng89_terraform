# create variables for our resources in main.tf to use

variable "aws_key_name" {
  default = "eng89_tom_terraform"
}

variable "aws_key_path" {
  default = "~/.ssh/eng89_tom_terraform.pem"
}

variable "cidr_block" {
  default = "10.205.0.0/16"
}

variable "ami_id" {
  default = "ami-038d7b856fe7557b3"
}

variable "vpc_name" {
  default = "eng89_tom_terra_vpc"
}

variable "igw_name" {
  default = "eng89_tom_terra_igw"
}
