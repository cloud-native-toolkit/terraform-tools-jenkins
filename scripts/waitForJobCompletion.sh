#!/usr/bin/env bash

NAMESPACE="$1"

echo "*** Waiting for jenkins-config job to complete"
kubectl -n "${NAMESPACE}" wait --for=condition=complete --timeout=10m "job/jenkins-config"
kubectl -n "${NAMESPACE}" wait --for=condition=complete --timeout=0 "job/jenkins-config"

API_TOKEN=$(kubectl -n "${NAMESPACE}" get secret jenkins-access -o jsonpath='{.data.api_token}' | base64 -d)

if [[ -z "${API_TOKEN}" ]] || [[ "${API_TOKEN}" == "undefined" ]] || [[ $(echo -n "${API_TOKEN}" | base64) == "undefined" ]]; then
  echo "The Jenkins api token has not been set after job completion"
  exit 1
else
  echo "The Jenkins api token has been set after job completion"
fi
