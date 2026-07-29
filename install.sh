#!/bin/bash

set -euxo pipefail

if [[ -z ${NAMESPACE:-} ]]; then 
    echo "Environment variable NAMESPACE is required." 
    echo "Example: NAMESPACE=test ./install.sh"
    exit 1
fi

export REPO="${REPO:-ethersphere/bee}"
export TAG="${TAG:-latest}"
export IMAGE_SETUP_TAG="${IMAGE_SETUP_TAG:-0.9.4}"
export GETH_ONLY="${GETH_ONLY:-false}"

echo "INSTALLING GETH"
helmsman -apply -subst-env-values -f bee.yaml -target geth

# wait for hardhat setup contracts job to complete
kubectl wait --for=condition=complete job/geth-swap-setupcontracts -n "$NAMESPACE" --timeout=1200s

if [[ "$GETH_ONLY" == "true" ]]; then
    echo "GETH_ONLY is set, skipping bootnode and Bee nodes"
    exit 0
fi

echo "INSTALLING BEE NODES"
helmsman -apply -subst-env-values -f bee.yaml
