# let's build a script to connect to AWS and download/setup all dependencies
# keyword: provider aws 
provider "aws" {
	region = "eu-west-1"
}

# then we will run terraform init (to initialise)
# then we will move on to launch aws services