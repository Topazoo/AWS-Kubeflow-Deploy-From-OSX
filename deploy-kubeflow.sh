# Cluster Config
if [ -z "${CLUSTER_NAME}" ]; then
    echo "CLUSTER_NAME is unset. Please set with export CLUSTER_NAME=<name>"
    exit 1
fi

if [ -z "${CLUSTER_REGION}" ]; then
    echo "CLUSTER_REGION is unset. Using default [us-west-2]"
    CLUSTER_REGION="us-west-2"
fi

if [ -z "${NODEGROUP_NAME}" ]; then
    echo "NODEGROUP_NAME is unset. Using default [linux-nodes]"
    NODEGROUP_NAME="linux-nodes"
fi

if [ -z "${NODE_TYPE}" ]; then
    echo "NODE_TYPE is unset. Using default [m5.xlarge]"
    NODE_TYPE="m5.xlarge"
fi

if [ -z "${NODES}" ]; then
    echo "NODES is unset. Using default [1]"
    NODES="1"
fi

if [ -z "${NODES_MIN}" ]; then
    echo "NODES_MIN is unset. Using default [1]"
    NODES_MIN="1"
fi

if [ -z "${NODES_MAX}" ]; then
    echo "NODES_MAX is unset. Using default [1]"
    NODES_MAX="1"
fi

if [ -z "${CLUSTER_K8S_VERSION}" ]; then
    echo "CLUSTER_K8S_VERSION is unset. Using default [1.23]"
    CLUSTER_K8S_VERSION="1.23"
fi

# AWS Config
if [ -z "${AWS_ACCESS_KEY_ID}" ]; then
    echo "AWS_ACCESS_KEY_ID is unset. Please set with export AWS_ACCESS_KEY_ID=<id>"
    exit 1
fi

if [ -z "${AWS_SECRET_ACCESS_KEY}" ]; then
    echo "AWS_SECRET_ACCESS_KEY is unset. Please set with export AWS_SECRET_ACCESS_KEY=<secret>"
    exit 1
fi

# Kubeflow Config
if [ -z "${KUBEFLOW_RELEASE_VERSION}" ]; then
    echo "KUBEFLOW_RELEASE_VERSION is unset. Using default [v1.6.1]"
    KUBEFLOW_RELEASE_VERSION="v1.6.1"
fi

if [ -z "${AWS_RELEASE_VERSION}" ]; then
    echo "AWS_RELEASE_VERSION is unset. Using default [v1.6.1-aws-b1.0.0]"
    AWS_RELEASE_VERSION="v1.6.1-aws-b1.0.0"
fi

docker container run -it -p 127.0.0.1:8080:8080 \
-e CLUSTER_NAME=${CLUSTER_NAME} \
-e CLUSTER_REGION=${CLUSTER_REGION} \
-e NODEGROUP_NAME=${NODEGROUP_NAME} \
-e NODE_TYPE=${NODE_TYPE} \
-e NODES=${NODES} \
-e NODES_MIN=${NODES_MIN} \
-e NODES_MAX=${NODES_MAX} \
-e CLUSTER_K8S_VERSION=${CLUSTER_K8S_VERSION} \
-e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
-e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
-e KUBEFLOW_RELEASE_VERSION=${KUBEFLOW_RELEASE_VERSION} \
-e AWS_RELEASE_VERSION=${AWS_RELEASE_VERSION} \
ubuntu:18.04 /bin/bash -c \
"echo '#!/bin/bash 
echo \"Installing dependencies in container...\"
apt update && apt install git curl unzip tar make sudo vim wget -y
echo \"Dependencies installed!\"
echo \"Building tools...!\"
git clone https://github.com/awslabs/kubeflow-manifests.git && cd kubeflow-manifests
git checkout $AWS_RELEASE_VERSION
git clone --branch $KUBEFLOW_RELEASE_VERSION https://github.com/kubeflow/manifests.git upstream
make install-tools
alias python=python3.8
echo \"Tools built!\"
echo \"Creating cluster...\"
eksctl create cluster \
--name $CLUSTER_NAME \
--version $CLUSTER_K8S_VERSION \
--region $CLUSTER_REGION \
--nodegroup-name $NODEGROUP_NAME \
--node-type $NODE_TYPE \
--nodes $NODES \
--nodes-min $NODES_MIN \
--nodes-max $NODES_MAX \
--managed \
--with-oidc
eksctl create addon --name aws-ebs-csi-driver --cluster $CLUSTER_NAME
echo \"Cluster created!\"
echo \"Deploying Kubeflow...\"
make deploy-kubeflow INSTALLATION_OPTION=kustomize DEPLOYMENT_OPTION=vanilla
echo \"Kubeflow deployed!\"
' > /script && chmod +x /script && /script"