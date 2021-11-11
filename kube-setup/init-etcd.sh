#!/bin/bash

pushd $(dirname $0)
PRIVATE_KEY="~/.ssh/kthw.id_rsa"

for instance in control-0 control-1 control-2; do
    external_ip=$(aws ec2 describe-instances --filters \
        "Name=tag:node,Values=${instance}" \
        "Name=instance-state-name,Values=running" \
        --output text --query 'Reservations[].Instances[].PublicIpAddress')

    ssh -o StrictHostKeyChecking=no -i ${PRIVATE_KEY} ec2-user@${external_ip} "bash -s" -- <<'EOF'
sudo cp ca.pem kubernetes-key.pem kubernetes.pem /etc/etcd/
sudo systemctl daemon-reload
sudo systemctl enable etcd
sudo systemctl start etcd
EOF

done

popd
