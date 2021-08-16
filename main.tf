# let's build a script to connect to AWS and download/setup all dependencies
# keyword: provider -> aws 

provider "aws" {
	region = "eu-west-1"
}

# then we will run terraform init (to initialise) in terminal/gitbash
# then we will move on to launch aws services

# lets launch an ec2 instance in eu-west-1 with ami-038d7b856fe7557b3 - ubuntu 16.04
# keyword: resource -> provide resource name and give specific details to service
# aws_ec2_instance, name, ami, type of instance, with/without ip - tags is keyword to name it

resource "aws_instance" "app_instance" {
	ami = "ami-038d7b856fe7557b3"
	instance_type = "t2.micro"
	associate_public_ip_address = true
	tags = {
		Name = "eng89_tom_terraform"
	}

}

# terraform plan checks syntax and validates instructions
# when outcome is all green, run terraform apply to run the script