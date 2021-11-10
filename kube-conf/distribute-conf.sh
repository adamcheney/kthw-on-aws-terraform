#!/bin/bash

PRIVATE_KEY="~/.ssh/kthw.id_rsa"

# distribute to workers
for instance in worker-0 worker-1 worker-2; do
  external_ip=$(aws ec2 describe-instances --filters \
    "Name=tag:node,Values=${instance}" \
    "Name=instance-state-name,Values=running" \
    --output text --query 'Reservations[].Instances[].PublicIpAddress')
  
  echo "Uploading config to ${instance}"
  scp -o StrictHostKeyChecking=no -i ${PRIVATE_KEY} \
    conf/${instance}.kubeconfig conf/kube-proxy.kubeconfig ec2-user@${external_ip}:~/
done

# distribute to controllers
for instance in control-0 control-1 control-2; do
  external_ip=$(aws ec2 describe-instances --filters \
    "Name=tag:node,Values=${instance}" \
    "Name=instance-state-name,Values=running" \
    --output text --query 'Reservations[].Instances[].PublicIpAddress')
  
  echo "Uploading config to ${instance}"
  scp -o StrictHostKeyChecking=no -i ${PRIVATE_KEY} \
    conf/admin.kubeconfig conf/kube-controller-manager.kubeconfig conf/kube-scheduler.kubeconfig ec2-user@${external_ip}:~/
done