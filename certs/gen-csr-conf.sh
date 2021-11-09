#!/usr/bin/env bash

infile="./conf/csr-template.json"

function generate_csr {
  cat ${infile} | jq ".CN=\"${1}\" | .names[].O=\"${2}\"" > ${3}
}

# GENERATE CA CSR
generate_csr "Kubernetes" "Kubernetes" "./conf/ca-csr.json"
# GENERATE ADMIN CSR
generate_csr "admin" "system:masters" "./conf/admin-csr.json"
# GENERATE CONTROLLER MANAGER CSR
generate_csr "system:kube-controller-manager" "system:kube-controller-manager" "./conf/kube-controller-manager-csr.json"
# GENERATE KUBE PROXY CSR
generate_csr "system:kube-proxy" "system:node-proxier" "./conf/kube-proxy-csr.json"
# GENERATE SCHEDULER CSR
generate_csr "system:kube-scheduler" "system:kube-scheduler" "./conf/kube-scheduler-csr.json"
# GENERATE KUBE API CSR
generate_csr "kubernetes" "Kubernetes" "./conf/kubernetes-csr.json"
# GENERATE SERVICE ACCOUNT CSR
generate_csr "service-accounts" "Kubernetes" "./conf/service-account-csr.json"
# GENERATE WORKER CSR
for instance in worker-0 worker-1 worker-2
do
  generate_csr "system:node:${instance}" "system:nodes" "./conf/${instance}-csr.json"
done
# GENERATE CONTROLLER CSR