#!/bin/bash

set -euxo pipefail

if [[ -z $NAMESPACE ]]; then 
    echo "Environment variable NAMESPACE is required." 
    echo "Example: NAMESPACE=test ./install.sh"
    exit 1
fi

echo "INSTALLING BEE BOOTNODE"
helmsman -apply -f bee-bootnode.yaml
BOOTNODE_FQDN=${BOOTNODE_FQDN:-"bee-bootnode-0-debug.$NAMESPACE.core.internal"}
echo BOOTNODE_FQDN=$BOOTNODE_FQDN

echo "RETREIVING BOOTNODE's MULTIADDRESS"
sleep 3
multiaddresses=$(curl -s "http://$BOOTNODE_FQDN/addresses" | jq '.underlay')
for ma in $multiaddresses
do
    multiaddress=$(grep -Eo '\/ip4\/(192\.168|10\.|172\.1[6789]\.|172\.2[0-9]\.|172\.3[01]\.).*\/tcp\/7070\/p2p\/[a-zA-Z0-9]*' <<< $ma) || true
    if [[ $multiaddress ]]
    then
        export BEE_CONFIG_BOOTNODE=$multiaddress
        echo BEE_CONFIG_BOOTNODE=$BEE_CONFIG_BOOTNODE
    fi
done

echo "INSTALLING BEE NODES"
helmsman -apply -f bee.yaml
