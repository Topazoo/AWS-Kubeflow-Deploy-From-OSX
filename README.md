# OSX-Kubeflow-AWS-Deploy

Single command to deploy [Kubeflow](https://awslabs.github.io/kubeflow-manifests/release-v1.6.1-aws-b1.0.0/) to EKS on AWS from OSX

## Requirements

[Docker for Mac](https://docs.docker.com/desktop/install/mac-install/)

## Overview

Deploying the most recent versions of Kubeflow to AWS is not trivial when using OSX.

Per Kubeflow's documentation, deploys must be done in a Dockerized Ubuntu instance: [https://awslabs.github.io/kubeflow-manifests/release-v1.6.1-aws-b1.0.0/docs/deployment/prerequisites/](https://awslabs.github.io/kubeflow-manifests/release-v1.6.1-aws-b1.0.0/docs/deployment/prerequisites/)

This script makes this operation a one-liner (minus some configuration)

## Quick Start

This creates a single-node EKS cluster named "kubeflow" on us-west-2 and deploys Kubeflow on the cluster:

```sh
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
export CLUSTER_NAME=kubeflow

./deploy-kubeflow.sh
```

## Additional Config

The following additional arguments can be specified via environmental variables:

```sh
# The AWS Region to create the cluster on
export CLUSTER_REGION="us-west-2"
```

```sh
# The Node group name for the cluster on
export NODEGROUP_NAME="linux-nodes"
```

```sh
# The EC2 instance type for the cluster
export NODE_TYPE="m5.xlarge"
```

```sh
# The starting number of nodes for the cluster
export NODES=1
```

```sh
# The minimum number of nodes for the cluster
export NODES_MIN=1
```

```sh
# The maximum number of nodes for the cluster
export NODES_MAX=1
```

```sh
# The Kubernetes version for the cluster
export CLUSTER_K8S_VERSION="1.23"
```

```sh
# The Kubeflow version to deploy to the cluster
export KUBEFLOW_RELEASE_VERSION="v1.6.1"
```

```sh
# The AWS Kubeflow version to deploy to the cluster
export AWS_RELEASE_VERSION="v1.6.1-aws-b1.0.0"
```
