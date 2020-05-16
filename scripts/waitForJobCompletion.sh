#!/usr/bin/env bash

NAMESPACE="$1"

echo "*** Waiting for jenkins-config job to complete"
kubectl -n "${NAMESPACE}" wait --for=condition=complete --timeout=10m "job/jenkins-config"
kubectl -n "${NAMESPACE}" wait --for=condition=complete --timeout=0 "job/jenkins-config"
