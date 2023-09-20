#!/bin/bash

KUBE_NS="default"

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
  annotations:
    kubernetes.io/service-account.name: "${SA_NAME}"
EOF
fi
TOKEN=$(kubectl get -n ${KUBE_NS} secret/${SA_SECRET} -o jsonpath='{.data.token}' | base64 -d)

kubectl get -n default secret/sa-default-token -o jsonpath='{.data.token}' | base64 -d

eyJhbGciOiJSUzI1NiIsImtpZCI6Im9YbE1vQ2xQeG82UEhMZzgzVTZOaGRvTngxSUVCcV9DNUFNSFFOaUhmMXcifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6InNhLWRlZmF1bHQtdG9rZW4iLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoic2EtZGVmYXVsdCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjJmZGUwYjgwLWJiZGUtNGViYi04N2UyLTIwOThjOGM3Mjc5OSIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpkZWZhdWx0OnNhLWRlZmF1bHQifQ.vo9pEpfMLu4jnaiesFvAdo-vbZNnnAyD_nhFavMgAta5rket4N9aU9IVaQWDhfbjR1izhymtdlc5K71mJFBQUL8nRRq_mja40um7CFreL8mo4kw51X2wGhIUof16JGDphC0FNJuLkYX2og4duxNxEAnijfAgb7H42OjSvfH5kiad9Vktu0jmV0X-63UFC7f1U2f8tbif8DmKfqvsSF66U9xY58SWxegTDddQ_74xTjkZ_3WJDqYf8ZWkK1SYxn3edw0S_ZOc_vt7BBWYlG5-0-s4yklrvItkVBSSivqx9x80fKufKAycOhER5gwkqT46_Y8zy-Vmpq3n0xC2XSy0XeHx1K0B9-rkUq6HNh6-eAX0woG5IGLez8WKbqyZKQv1qr5uVJjiWOSF64eClB4QqSBvGifIPXK3AyVYjGMN8VEDdBvJvirHmnsAre7kspwnNl81K0eCHXfCxkRYTdlmnFJuIEto-2tIPEL1qCc_ZwrLR_9U6I0_7dIXq-Ui-sorRpY_g4_yZvWJpDh9xxgKY5l514xGR68NqmQpccR8hBE4TEFzY6RlYUAhy2E8a7126wkefs2NKQ8qeucczIa_b0jsgPXAeVWZAlCLeukIyCK18s-5HeKo-hSVhLqhTzGx58rOOn2VMKUKaqVnEQmo98_mbiOErMquoocHRxDpm7Q