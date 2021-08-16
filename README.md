# Terraform
- lightweight and quick setup
- powerful
- .tf syntax files is similar to json {}
- main.tf contains instructions
- set AWS access keys as environment variables - AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
- there are other options - secret.txt, vaults, .gitignore - but variables is most secure
- put .terraform/ in the .gitignore as it gets large and heavy to push every time
- terraform gathers dependencies when it is initialised with `terraform init` using the `main.tf` instructions