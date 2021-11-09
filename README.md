# kthw-on-aws-terraform
Kelsey Hightower's Kubernetes the Hard Way executed in a new AWS account with Terraform

## setup
`terraform apply` in backend-setup to create the s3 bucket for terraform state.

Ensure your creds are in both backend-setup/variables.tf and ./variables.tf

## requirements
requires `cfssl` and `cfssljson` to generate certs for nodes

access to an aws account

## generating certs

To generate and distribute the certs to your infra, run `gen-csr-conf.sh` followed by `gen-keys.sh` then `distribute-certs.sh` in the certs folder.

## security

By default the terraform exposes a number of ports directly on the instances themselves. This is to allow ssh access for uploading configuration to the instances. After you've run the setup scripts it might be worth disabling some of this access, so that the only possible access is via the load balancer