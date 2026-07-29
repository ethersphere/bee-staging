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

To install Bee cluster that consists of Bee bootnode and multiple Bee nodes execute following command:

```bash
NAMESPACE=test ./install.sh
```

You can also specify different repo and tag with

```bash
NAMESPACE=bee-playground REPO=ethersphere/bee TAG=latest ./install.sh
```

It will execute bee.yaml Helmsman DSF file.

### Installing geth only

The script always deploys the `geth-swap` chain first and waits for the `geth-swap-setupcontracts` job to deploy the swap contracts, then installs the bootnode and Bee nodes. To stop after the chain and contracts are ready — useful when you only need a local chain to point other nodes at — set `GETH_ONLY`:

```bash
NAMESPACE=bee-playground GETH_ONLY=true ./install.sh
```

The Bee nodes can be added later by re-running the script without `GETH_ONLY`.

### Environment variables

| Variable | Required | Default | Description |
| --- | --- | --- | --- |
| `NAMESPACE` | yes | — | Kubernetes namespace to deploy into |
| `REPO` | no | `ethersphere/bee` | Bee image repository |
| `TAG` | no | `latest` | Bee image tag |
| `IMAGE_SETUP_TAG` | no | `0.9.4` | `ethersphere/bee-localchain` tag used by the `geth-swap-setupcontracts` job |
| `GETH_ONLY` | no | `false` | When `true`, deploy only geth and the swap contracts, skipping the bootnode and Bee nodes |

**Note:** Helmsman does not support shell-style default values in the DSF file. `${VAR:-default}` is parsed as a variable literally named `VAR:-default`, which never resolves, so it is substituted with an empty string — for example `imageSetupContract.tag: ${IMAGE_SETUP_TAG:-0.9.4}` yields the invalid image `ethersphere/bee-localchain:` and the job pod fails with `InvalidImageName`. Defaults are therefore set in `install.sh` and referenced as plain `$VAR` in `bee.yaml`.

Helmsman validates every variable referenced in the DSF on **all** operations, including `-destroy`. `uninstall.sh` therefore sets `IMAGE_SETUP_TAG` as well, even though the value has no effect when destroying releases — leaving it unset aborts with `$IMAGE_SETUP_TAG is used as an env variable but is currently unset`.

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

## Maintainers

- [Bee](https://github.com/orgs/ethersphere/teams/bee) team
- [DevOps](https://github.com/orgs/ethersphere/teams/devops) team
