#!/bin/bash

set -euxo pipefail

if [[ -z $NAMESPACE ]]; then 
    echo "Environment variable NAMESPACE is required." 
    echo "Example: NAMESPACE=test ./uninstall.sh"
    exit 1
fi

echo "DESTROYING BEE NODES"
helmsman -destroy -f bee.yaml

echo "DELETING BEE NODE PVCs"
kubectl delete pvc --selector=app.kubernetes.io/name=bee -n $NAMESPACE
