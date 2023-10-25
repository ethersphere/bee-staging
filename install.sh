#!/bin/bash

set -euxo pipefail

if [[ -z $NAMESPACE ]]; then 
    echo "Environment variable NAMESPACE is required." 
    echo "Example: NAMESPACE=test ./install.sh"
    exit 1
fi

echo "INSTALLING BEE NODES"
helmsman -apply -subst-env-values -f bee.yaml
