# kthw-on-aws-terraform
Kelsey Hightower's Kubernetes the Hard Way executed in a new AWS account with Terraform

## setup
`terraform apply` in backend-setup to create the s3 bucket for terraform state.

Ensure your creds are in both backend-setup/variables.tf and ./variables.tf

## requirements
requires `cfssl` and `cfssljson` to generate certs for nodes

access to an aws account