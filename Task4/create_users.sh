#!/bin/bash

echo "=== Генерация ключей и CSR для developer1 ==="
openssl genrsa -out developer1.key 2048
openssl req -new -key developer1.key -out developer1.csr -subj "/CN=developer1/O=propdev-developers"

echo "=== Отправка CSR для developer1 ==="
cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: developer1
spec:
  request: $(cat developer1.csr | base64 | tr -d '\n')
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 86400
  usages:
  - client auth
EOF

kubectl certificate approve developer1
kubectl get csr developer1 -o jsonpath='{.status.certificate}' | base64 --decode > developer1.crt

echo "=== Генерация ключей и CSR для viewer1 ==="
openssl genrsa -out viewer1.key 2048
openssl req -new -key viewer1.key -out viewer1.csr -subj "/CN=viewer1/O=propdev-viewers"

echo "=== Отправка CSR для viewer1 ==="
cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: viewer1
spec:
  request: $(cat viewer1.csr | base64 | tr -d '\n')
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 86400
  usages:
  - client auth
EOF

kubectl certificate approve viewer1
kubectl get csr viewer1 -o jsonpath='{.status.certificate}' | base64 --decode > viewer1.crt

echo "✅ Пользователи созданы."