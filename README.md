# kthw-on-aws-terraform
Kelsey Hightower's Kubernetes the Hard Way executed in a new AWS account with Terraform

## setup
`terraform apply` in backend-setup to create the s3 bucket for terraform state.

Ensure your creds are in both backend-setup/variables.tf and ./variables.tf

## requirements
requires `cfssl` and `cfssljson` to generate certs for nodes

access to an aws account

## generating certs and config

For both of these you'll need to generate your own ssh key pair and specify the public key in the top level `variables.tf` file. In `distribute-certs.sh` and `distribute-conf.sh` you'll need to provide the path to your private key.

To generate and distribute the certs to your infra, run `gen-csr-conf.sh` followed by `gen-keys.sh` then `distribute-certs.sh` in the certs folder.

To generate and distribute config to your infra, run `generate-conf.sh` followed by `distribute-conf.sh` in the kube-conf folder.

## security

By default the terraform exposes a number of ports directly on the instances themselves. This is to allow ssh access for uploading configuration to the instances. After you've run the setup scripts it might be worth disabling some of this access, so that the only possible access is via the load balancer