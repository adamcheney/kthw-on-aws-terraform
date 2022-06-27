#!/bin/bash

pushd $(dirname $0)
PRIVATE_KEY="~/.ssh/kthw.id_rsa"

for instance in worker-0 worker-1 worker-2; do
  external_ip=$(aws ec2 describe-instances --filters \
    "Name=tag:node,Values=${instance}" \
    "Name=instance-state-name,Values=running" \
    --output text --query 'Reservations[].Instances[].PublicIpAddress')

    ssh -o StrictHostKeyChecking=no -i ${PRIVATE_KEY} ec2-user@${external_ip} "bash -s" <<EOF
sudo mv ${instance}-key.pem ${instance}.pem /var/lib/kubelet/
sudo mv ${instance}.kubeconfig /var/lib/kubelet/kubeconfig
sudo mv ca.pem /var/lib/kubernetes/
sudo mv kube-proxy.kubeconfig /var/lib/kube-proxy/kubeconfig

sudo systemctl daemon-reload
sudo systemctl enable containerd kubelet kube-proxy
sudo systemctl start containerd kubelet kube-proxy

EOF

done

popd
