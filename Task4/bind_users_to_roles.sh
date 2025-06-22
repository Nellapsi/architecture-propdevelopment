#!/bin/bash

echo "=== Добавление пользователей в kubeconfig ==="
kubectl config set-credentials developer1 \
  --client-certificate=./developer1.crt \
  --client-key=./developer1.key

kubectl config set-credentials viewer1 \
  --client-certificate=./viewer1.crt \
  --client-key=./viewer1.key

echo "=== Создание контекстов для пользователей ==="
kubectl config set-context dev-developer1 \
  --cluster=minikube \
  --user=developer1

kubectl config set-context dev-viewer1 \
  --cluster=minikube \
  --user=viewer1

echo "✅ Контексты созданы."