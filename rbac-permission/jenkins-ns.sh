#!/bin/bash

KUBE_NS="jenkins"

if [[ ! -n $(kubectl get ns --field-selector=metadata.name=${KUBE_NS} --no-headers 2> /dev/null) ]]; then
  echo Namespace $KUBE_NS not found!
  exit 1
fi

if [[ ! -n "${SA_NAME}" ]]; then
  SA_NAME=sa-${KUBE_NS}
fi

kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  namespace: ${KUBE_NS}
  name: ${SA_NAME}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  namespace: ${KUBE_NS}
  name: ${SA_NAME}-admin-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: ${SA_NAME}
  namespace: ${KUBE_NS}
EOF

SA_SECRET=$(kubectl get -n ${KUBE_NS} serviceaccount/${SA_NAME} -o jsonpath='{.secrets[0].name}')
if [[ ! -n "${SA_SECRET}" ]]; then
SA_SECRET="${SA_NAME}-token"
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
type: kubernetes.io/service-account-token
metadata:
  name: ${SA_SECRET}
  namespace: ${KUBE_NS}
  annotations:
    kubernetes.io/service-account.name: "${SA_NAME}"
EOF
fi
TOKEN=$(kubectl get -n ${KUBE_NS} secret/${SA_SECRET} -o jsonpath='{.data.token}' | base64 -d)

# kubectl get -n jenkins secret/sa-default-token -o jsonpath='{.data.token}' | base64 -d
