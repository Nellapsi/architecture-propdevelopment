#!/bin/bash

echo "=== Установка роли propdev-cluster-admin ==="
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: propdev-cluster-admin
rules:
- apiGroups: ["*"]
  resources: ["*"]
  verbs: ["*"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: bind-propdev-admins
subjects:
- kind: Group
  name: propdev-admins
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: propdev-cluster-admin
  apiGroup: rbac.authorization.k8s.io
EOF

echo "=== Установка роли propdev-app-editor ==="
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: propdev-app-editor
rules:
- apiGroups: [""]
  resources: ["pods", "services", "configmaps", "secrets"]
  verbs: ["get", "list", "create", "update", "delete"]
- apiGroups: ["apps"]
  resources: ["deployments", "statefulsets"]
  verbs: ["get", "list", "create", "update", "delete"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  namespace: default
  name: bind-propdev-developers
subjects:
- kind: Group
  name: propdev-developers
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: propdev-app-editor
  apiGroup: rbac.authorization.k8s.io
EOF

echo "=== Установка роли propdev-app-viewer ==="
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: propdev-app-viewer
rules:
- apiGroups: [""]
  resources: ["pods", "services", "configmaps", "secrets"]
  verbs: ["get", "list"]
- apiGroups: ["apps"]
  resources: ["deployments", "statefulsets"]
  verbs: ["get", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  namespace: default
  name: bind-propdev-viewers
subjects:
- kind: Group
  name: propdev-viewers
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: propdev-app-viewer
  apiGroup: rbac.authorization.k8s.io
EOF

echo "✅ RBAC настроен."