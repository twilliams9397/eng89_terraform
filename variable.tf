# create variables for our resources in main.tf to use

variable "aws_key_name" {
  default = "eng89_tom_terraform"
}

variable "aws_key_path" {
  default = "~/.ssh/eng89_tom_terraform.pem"
}