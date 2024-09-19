#!/bin/bash

set -euxo pipefail

if [[ -z $NAMESPACE ]]; then 
    echo "Environment variable NAMESPACE is required." 
    echo "Example: NAMESPACE=test ./install.sh"
    exit 1
fi

export REPO="${REPO:-ethersphere/bee}"
export TAG="${TAG:-latest}"

echo "INSTALLING BEE NODES"

helmsman -apply -subst-env-values -f bee.yaml -target geth

# wait for hardhat setup contracts job to complete
kubectl wait --for=condition=complete job/geth-swap-setupcontracts -n "$NAMESPACE" --timeout=1200s
helmsman -apply -subst-env-values -f bee.yaml
