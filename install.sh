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
helmsman -apply -subst-env-values -f bee.yaml
