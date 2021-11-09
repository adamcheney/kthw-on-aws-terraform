#!/bin/zsh

mkdir -p certs
# GENERATE CA CERT + KEYS
cfssl gencert -initca certs/ca-csr.json | cfssljson -bare certs/ca
# GENERATE ADMIN CERT + KEYS
cfssl gencert \
  -ca=conf/ca.pem \
  -ca-key=conf/ca-key.pem \
  -config=conf/ca-config.json \
  -profile=kubernetes \
  conf/admin-csr.json | cfssljson -bare certs/admin
# GENERATE WORKER CERT + KEYS

aws_desc="/usr/local/bin/aws ec2 describe-instances";
jq="/usr/local/bin/jq"
jq_publicip='.Reservations[].Instances[] | select(.State.Name=="running") | .PublicIpAddress'
jq_privateip='.Reservations[].Instances[] | select(.State.Name=="running") | .PrivateIpAddress'
for instance in worker-0 worker-1 worker-2
do
  # jsonnode=$(${aws_desc} --filters "Name=tag:node,Values=${instance}")
  # extip=$(${jq} ${jq_publicip} \'${jsonnode}\')
  extip=$(${aws_desc} --filters "Name=tag:node,Values=${instance}" | ${jq} "${jq_publicip}")
  intip=$(${aws_desc} --filters "Name=tag:node,Values=${instance}" | ${jq} "${jq_privateip}")

  cfssl gencert \
  -ca=conf/ca.pem \
  -ca-key=conf/ca-key.pem \
  -config=conf/ca-config.json \
  -hostname=${instance_hostname},${external_ip},${internal_ip} \
  -profile=kubernetes \
  conf/worker-${i}-csr.json | cfssljson -bare certs/worker-${i}
done

# GENERATE CONTROLLER MANAGER CERT + KEYS
cfssl gencert \
  -ca=conf/ca.pem \
  -ca-key=conf/ca-key.pem \
  -config=conf/ca-config.json \
  -profile=kubernetes \
  conf/kube-controller-manager-csr.json | cfssljson -bare certs/kube-controller-manager

# GENERATE KUBE PROXY CERT + KEYS
cfssl gencert \
  -ca=conf/ca.pem \
  -ca-key=conf/ca-key.pem \
  -config=conf/ca-config.json \
  -profile=kubernetes \
  conf/kube-proxy-csr.json | cfssljson -bare certs/kube-proxy

# GENERATE SCHEDULER CERT + KEYS
cfssl gencert \
  -ca=conf/ca.pem \
  -ca-key=conf/ca-key.pem \
  -config=conf/ca-config.json \
  -profile=kubernetes \
  conf/kube-scheduler-csr.json | cfssljson -bare certs/kube-scheduler

# GENERATE KUBE API CERT + KEYS
KUBERNETES_PUBLIC_ADDRESS=$(aws elbv2 describe-load-balancers \
    --load-balancer-name kthw \ # see load_balancer.tf
    --output text --query 'LoadBalancers[].DNSName')
KUBERNETES_HOSTNAMES=kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.svc.cluster.local
CONTROLLER_IPS=10.240.1.10,10.240.2.10,10.240.3.10 # see locals.tf
cfssl gencert \
  -ca=conf/ca.pem \
  -ca-key=conf/ca-key.pem \
  -config=conf/ca-config.json \
  -hostname=10.32.0.1,${CONTROLLER_IPS},${KUBERNETES_PUBLIC_ADDRESS},127.0.0.1,${KUBERNETES_HOSTNAMES} \ # TODO: check 10.32.0.1 
  -profile=kubernetes \
  conf/kubernetes-csr.json | cfssljson -bare certs/kubernetes

# GENERATE SERVICE ACCOUNT CERT + KEYS
cfssl gencert \
  -ca=conf/ca.pem \
  -ca-key=conf/ca-key.pem \
  -config=conf/ca-config.json \
  -profile=kubernetes \
  conf/service-account-csr.json | cfssljson -bare certs/service-account