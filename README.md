# Bee staging deployments

This repository contains all the definitions for the Bee staging releases used by the Swarm Team.

We're using [helmsman](https://github.com/Praqma/helmsman) to manage the deployments to our kubernetes cluster. You can learn more about helmsman's [desired state specification](https://github.com/Praqma/helmsman/blob/master/docs/desired_state_specification.md).

## Prerequisites

* Kubernetes 1.15
* Helm 3.0
* Helmsman 3.0

## Installing

To install Bee cluster that consits of Bee bootnode and multiple Bee nodes execute following command:

```bash
$ NAMESPACE=bee ./install.sh 
```

It will execute two Helmsman DSF files, one for bee-bootnode, one for bee.

Both DSF files use official [Bee Helm Chart](https://github.com/ethersphere/helm/tree/master/charts/bee), and both are deployed in the same Kubernetes namespace.

[Helm values](https://github.com/ethersphere/bee-staging/tree/master/helm-values) are defaults used by the Swarm team, but everyone should setup those up to its own needs.

## Uninstalling

To uninstall previously deployed Bee cluster execute following command:

```bash
$ NAMESPACE=bee ./uninstall.sh 
```
