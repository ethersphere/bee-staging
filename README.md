# Bee staging deployments

This repository contains all the definitions for the Bee staging releases used by the Swarm Team.

We're using [helmsman](https://github.com/Praqma/helmsman) to manage the deployments to our Kubernetes cluster. You can learn more about Helmsman's [desired state specification](https://github.com/Praqma/helmsman/blob/master/docs/desired_state_specification.md).

## Prerequisites

* Kubernetes 1.15
* Helm 3.0
* Helmsman 3.0
* Helm diff (>=1.6.0) [.](https://github.com/databus23/helm-diff)
* jq (expected that binary is named `jq`, not `jq-linux` etc) [.](https://github.com/stedolan/jq)

## Installing

To install Bee cluster that consits of Bee bootnode and multiple Bee nodes execute following command:

```bash
NAMESPACE=test ./install.sh
```

You can also specify different repo and tag with

```bash
NAMESPACE=bee-playground REPO=ethersphere/bee TAG=latest ./install.sh
```

It will execute bee.yaml Helmsman DSF file.

Helmsman DSF file uses official [Bee Helm Chart](https://github.com/ethersphere/helm/tree/master/charts/bee), and it's deployed into specified Kubernetes namespace.

**Note:** Everyone should update name of the namespace to avoid overlapping with others if working on the same Kubernetes cluster.

**Note:** [Helm values](https://github.com/ethersphere/bee-staging/tree/master/helm-values) are defaults used by the Swarm team, but everyone should use setup up to its own needs.

## Configuration

Configuration parameters can be set in 2 ways:

* in the Helmsman DSF file, with the field **set**

```bash
apps:
  bee:
    set:
      image.repository: ethersphere/bee
      image.tag: latest
      replicaCount: 2
```

* in the Helm values file

```bash
image:
  repository: ethersphere/bee
  tag: latest

replicaCount: 2
```

See Bee Helm chart's [values.yaml](https://github.com/ethersphere/helm/blob/master/charts/bee/values.yaml) file for all available options.

## Uninstalling

To uninstall previously deployed Bee cluster execute following command:

```bash
NAMESPACE=test ./uninstall.sh 
```
