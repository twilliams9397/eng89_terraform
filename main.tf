# let's build a script to connect to AWS and download/setup all dependencies
# keyword: provider -> aws 
# this main file will take from all other .tf files to create the instances

provider "aws" {
	# setting aws region
	region = "eu-west-1"
}

# Database instance
resource "aws_instance" "db_instance" {
	key_name = var.aws_key_name 
	ami = var.ami_id
  subnet_id = aws_subnet.terraform_private_sub.id
  vpc_security_group_ids = ["${aws_security_group.db_sg.id}"]
	instance_type = "t2.micro"
	associate_public_ip_address = false

	tags = {
		Name = var.ec2_db_name
	}
}

# App instance
resource "aws_instance" "app_instance" {
	key_name = var.aws_key_name 
	ami = var.ami_id
	# creates instance in public subnet
  subnet_id = aws_subnet.terraform_public_sub.id
  # links security group to instance
  vpc_security_group_ids = ["${aws_security_group.app_sg.id}"]
	instance_type = "t2.micro"
	associate_public_ip_address = true
	# uploads local folder to instance
	provisioner "file" {
    source      = "/Users/Tom1/Documents/Sparta/Terraform/app"
    destination = "/home/ubuntu"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.aws_key_path)
      host        = self.public_ip
    }
  }
  # runs commands in instance
  provisioner "remote-exec" {
  	inline = [
  					"sudo apt-get update",
  					"cd app",
  					"sh provision.sh",
            "npm install",
            "node seeds/seed.js",
  					"node app.js"
  					]
  	connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.aws_key_path)
      host        = self.public_ip
    }
  }

	tags = {
		Name = var.ec2_name
	}
}
