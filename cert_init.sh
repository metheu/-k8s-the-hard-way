#!/bin/bash

# ENV VARS
export TLS_OU="RUSTY_STUFF"

BASE_IP_ADDR="192.168.56.1"
KUBERNETES_PUBLIC_ADDRESS="192.168.56.11" # lb ip so BASE_IP_ADDR + 1
CERT_DIR="pki"
PKI_TEMPLATE_DIR="pki_templates"
CERT_DIRS=("ca" "admin" "kube-controller-manager" "kube-proxy" "kube-scheduler" "api" "service-account")

if [ -d "$CERT_DIR" ]; then
  echo "$CERT_DIR exists; deleting!"
  rm -rf "$CERT_DIR"
fi

function replaceEnvVar {
  envsubst < $1 > $1.tmp
  mv -v $1.tmp $1
}

# ## Create respective directories and copy csr templates to respective folders
for dir in ${CERT_DIRS[@]}; do
   mkdir -pv "$CERT_DIR"/${dir}
  cp -v ${PKI_TEMPLATE_DIR}/$dir/* ${CERT_DIR}/$dir
done


# Worker certs prep work
for node in 4 5; do
  export NODE=node${node}
   mkdir -pv "$CERT_DIR"/clients
  cp -v ${PKI_TEMPLATE_DIR}/clients/node-csr.json ${CERT_DIR}/clients/node${node}-csr.json
  replaceEnvVar  ${CERT_DIR}/clients/node${node}-csr.json
  unset NODE
done

# env var substitution
for dir in $(pwd)/${CERT_DIR}/**/*; do
  for file in $dir; do
    if [[ -f $file ]]; then
      echo $file
      replaceEnvVar $file
    fi
  done
done


# Generate CA
cfssl gencert -initca ${CERT_DIR}/ca/ca-csr.json | cfssljson -bare ${CERT_DIR}/ca/ca

# Generate all except ca, since is generated first  and api||clients
for dir in ${CERT_DIRS[@]}; do
if [[ $dir != "ca" || $dir != "api" || $dir != "clients" ]]; then
  cfssl gencert \
    -ca=${CERT_DIR}/ca/ca.pem \
    -ca-key=${CERT_DIR}/ca/ca-key.pem \
    -config=${CERT_DIR}/ca/ca-config.json \
    -profile=kubernetes \
    ${CERT_DIR}/${dir}/*-csr.json | cfssljson -bare ${CERT_DIR}/${dir}/$dir
  fi
done


## Lets start generate the  worker keys
for node in 4 5; do
  cfssl gencert \
  -ca=${CERT_DIR}/ca/ca.pem \
  -ca-key=${CERT_DIR}/ca/ca-key.pem \
  -config=${CERT_DIR}/ca/ca-config.json \
  -hostname=node${node},${BASE_IP_ADDR}${node} \
  -profile=kubernetes \
  ${CERT_DIR}/clients/node${node}-csr.json | cfssljson -bare ${CERT_DIR}/clients/node${node}
done

# kube api key
cfssl gencert \
  -ca=pki/ca/ca.pem \
  -ca-key=pki/ca/ca-key.pem \
  -config=pki/ca/ca-config.json \
  -hostname=10.32.0.1,${BASE_IP_ADDR}2,${BASE_IP_ADDR}3,${KUBERNETES_PUBLIC_ADDRESS},127.0.0.1,kubernetes.default \
  -profile=kubernetes \
  ${CERT_DIR}/api/kubernetes-csr.json | cfssljson -bare ${CERT_DIR}/api/kubernetes
