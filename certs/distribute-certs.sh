#!/bin/bash
pushd $(dirname $0)

PRIVATE_KEY="~/.ssh/kthw.id_rsa"

# DISTRIBUTE CONTROLLER CERTS AND KEYS
for instance in control-0 control-1 control-2; do
  external_ip=$(aws ec2 describe-instances --filters \
    "Name=tag:node,Values=${instance}" \
    "Name=instance-state-name,Values=running" \
    --output text --query 'Reservations[].Instances[].PublicIpAddress')

  echo "Uploading to ${instance}"
  scp -o StrictHostKeyChecking=no -i ${PRIVATE_KEY} \
    certs/ca.pem certs/ca-key.pem certs/kubernetes-key.pem certs/kubernetes.pem \
    certs/service-account-key.pem certs/service-account.pem ec2-user@${external_ip}:~/
done

# DISTRIBUTE WORKER CERTS AND KEYS
for instance in worker-0 worker-1 worker-2; do
  echo "Uploading to ${instance}"
  external_ip=$(aws ec2 describe-instances --filters \
    "Name=tag:node,Values=${instance}" \
    "Name=instance-state-name,Values=running" \
    --output text --query 'Reservations[].Instances[].PublicIpAddress')

  scp -o StrictHostKeyChecking=no -i ${PRIVATE_KEY} certs/ca.pem certs/${instance}-key.pem certs/${instance}.pem ec2-user@${external_ip}:~/
done

popd