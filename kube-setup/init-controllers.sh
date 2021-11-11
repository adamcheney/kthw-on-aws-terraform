#!/bin/bash

pushd $(dirname $0)
PRIVATE_KEY="~/.ssh/kthw.id_rsa"

for instance in control-0 control-1 control-2; do
    echo "Init etcd and kubes daemons for ${instance} (the first one may timeout starting etcd)"
    external_ip=$(aws ec2 describe-instances --filters \
        "Name=tag:node,Values=${instance}" \
        "Name=instance-state-name,Values=running" \
        --output text --query 'Reservations[].Instances[].PublicIpAddress')

    ssh -o StrictHostKeyChecking=no -i ${PRIVATE_KEY} ec2-user@${external_ip} "bash -s" <<EOF
sudo cp ca.pem kubernetes-key.pem kubernetes.pem /etc/etcd/

sudo mv ca.pem ca-key.pem kubernetes-key.pem kubernetes.pem \
    service-account-key.pem service-account.pem \
    encryption-config.yaml /var/lib/kubernetes/

sudo mv kube-controller-manager.kubeconfig /var/lib/kubernetes/

sudo mv kube-scheduler.kubeconfig /var/lib/kubernetes/

sudo systemctl daemon-reload
sudo systemctl enable kube-apiserver kube-controller-manager kube-scheduler etcd
sudo systemctl start kube-apiserver kube-controller-manager kube-scheduler etcd
        
EOF &

done

echo "Done starting etcd and kubes daemons -- beginning RBAC init"

# rbac init

external_ip=$(aws ec2 describe-instances --filters \
    "Name=tag:node,Values=control-0" \
    "Name=instance-state-name,Values=running" \
    --output text --query 'Reservations[].Instances[].PublicIpAddress')

ssh -o StrictHostKeyChecking=no -i ${PRIVATE_KEY} ec2-user@${external_ip} "bash -s" <<EOF
cat <<EOF2 | kubectl apply --kubeconfig admin.kubeconfig -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  annotations:
    rbac.authorization.kubernetes.io/autoupdate: "true"
  labels:
    kubernetes.io/bootstrapping: rbac-defaults
  name: system:kube-apiserver-to-kubelet
rules:
  - apiGroups:
      - ""
    resources:
      - nodes/proxy
      - nodes/stats
      - nodes/log
      - nodes/spec
      - nodes/metrics
    verbs:
      - "*"
EOF2

cat <<EOF2 | kubectl apply --kubeconfig admin.kubeconfig -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: system:kube-apiserver
  namespace: ""
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: system:kube-apiserver-to-kubelet
subjects:
  - apiGroup: rbac.authorization.k8s.io
    kind: User
    name: kubernetes
EOF2
EOF

popd
