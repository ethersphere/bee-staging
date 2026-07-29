#!/bin/bash

set -euxo pipefail

if [[ -z ${NAMESPACE:-} ]]; then
    echo "Environment variable NAMESPACE is required." 
    echo "Example: NAMESPACE=test ./uninstall.sh"
    exit 1
fi

# helmsman validates every variable referenced in bee.yaml, including on
# -destroy, so this must be set even though the value is irrelevant here
export IMAGE_SETUP_TAG="${IMAGE_SETUP_TAG:-0.9.4}"

echo "DESTROYING BEE NODES"
helmsman -destroy -f bee.yaml

echo "DELETING BEE NODE PVCs"
kubectl delete pvc --selector=app.kubernetes.io/name=bee -n $NAMESPACE
kubectl delete pvc --selector=app.kubernetes.io/name=bootnode -n $NAMESPACE
kubectl delete pvc --selector=app.kubernetes.io/name=geth-swap -n $NAMESPACE
