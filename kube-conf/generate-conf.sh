#!/bin/bash

pushd $(dirname $0)

mkdir -p conf

KUBERNETES_PUBLIC_ADDRESS=$(aws elbv2 describe-load-balancers \
    --names kthw \
    --output text --query 'LoadBalancers[].DNSName')

# worker config
for instance in worker-0 worker-1 worker-2; do
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=../certs/certs/ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_PUBLIC_ADDRESS}:443 \
    --kubeconfig=conf/${instance}.kubeconfig

  kubectl config set-credentials system:node:${instance} \
    --client-certificate=../certs/certs/${instance}.pem \
    --client-key=../certs/certs/${instance}-key.pem \
    --embed-certs=true \
    --kubeconfig=conf/${instance}.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:node:${instance} \
    --kubeconfig=conf/${instance}.kubeconfig

  kubectl config use-context default --kubeconfig=conf/${instance}.kubeconfig
done

# kube proxy config
kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=../certs/certs/ca.pem \
  --embed-certs=true \
  --server=https://${KUBERNETES_PUBLIC_ADDRESS}:443 \
  --kubeconfig=conf/kube-proxy.kubeconfig

kubectl config set-credentials system:kube-proxy \
  --client-certificate=../certs/certs/kube-proxy.pem \
  --client-key=../certs/certs/kube-proxy-key.pem \
  --embed-certs=true \
  --kubeconfig=conf/kube-proxy.kubeconfig

kubectl config set-context default \
  --cluster=kubernetes-the-hard-way \
  --user=system:kube-proxy \
  --kubeconfig=conf/kube-proxy.kubeconfig

kubectl config use-context default --kubeconfig=conf/kube-proxy.kubeconfig

# kube controller manager config
kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=../certs/certs/ca.pem \
  --embed-certs=true \
  --server=https://127.0.0.1:6443 \
  --kubeconfig=conf/kube-controller-manager.kubeconfig

kubectl config set-credentials system:kube-controller-manager \
  --client-certificate=../certs/certs/kube-controller-manager.pem \
  --client-key=../certs/certs/kube-controller-manager-key.pem \
  --embed-certs=true \
  --kubeconfig=conf/kube-controller-manager.kubeconfig

kubectl config set-context default \
  --cluster=kubernetes-the-hard-way \
  --user=system:kube-controller-manager \
  --kubeconfig=conf/kube-controller-manager.kubeconfig

kubectl config use-context default --kubeconfig=conf/kube-controller-manager.kubeconfig

# kube scheduler config
kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=../certs/certs/ca.pem \
  --embed-certs=true \
  --server=https://127.0.0.1:6443 \
  --kubeconfig=conf/kube-scheduler.kubeconfig

kubectl config set-credentials system:kube-scheduler \
  --client-certificate=../certs/certs/kube-scheduler.pem \
  --client-key=../certs/certs/kube-scheduler-key.pem \
  --embed-certs=true \
  --kubeconfig=conf/kube-scheduler.kubeconfig

kubectl config set-context default \
  --cluster=kubernetes-the-hard-way \
  --user=system:kube-scheduler \
  --kubeconfig=conf/kube-scheduler.kubeconfig

kubectl config use-context default --kubeconfig=conf/kube-scheduler.kubeconfig

# admin config
kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=../certs/certs/ca.pem \
  --embed-certs=true \
  --server=https://127.0.0.1:6443 \
  --kubeconfig=conf/admin.kubeconfig

kubectl config set-credentials admin \
  --client-certificate=../certs/certs/admin.pem \
  --client-key=../certs/certs/admin-key.pem \
  --embed-certs=true \
  --kubeconfig=conf/admin.kubeconfig

kubectl config set-context default \
  --cluster=kubernetes-the-hard-way \
  --user=admin \
  --kubeconfig=conf/admin.kubeconfig

kubectl config use-context default --kubeconfig=conf/admin.kubeconfig

# at rest encryption config
ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)
cat > conf/encryption-config.yaml <<EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ENCRYPTION_KEY}
      - identity: {}
EOF

popd