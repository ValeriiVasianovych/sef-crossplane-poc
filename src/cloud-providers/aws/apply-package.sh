#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../scripts/configure-shell.sh"

PROVIDER=$1
SERVICE=$2

printInfo "+++ Apply provider package: provider = ${PROVIDER} +++"
printInfo "+++ Apply Common Infrastructure XRD and Compositions +++"

# Install EKS XRD and Composition
kubectl apply -f "${SCRIPT_DIR}/infra-components/eks/definition.yaml"
kubectl apply -f "${SCRIPT_DIR}/infra-components/eks/composition.yaml"
kubectl apply -f "${SCRIPT_DIR}/infra-components/eks/func.yaml"

# Install RDS XRD and Composition
kubectl apply -f "${SCRIPT_DIR}/infra-components/rds/definition.yaml"
kubectl apply -f "${SCRIPT_DIR}/infra-components/rds/composition.yaml"

# Install SQS XRD and Composition
kubectl apply -f "${SCRIPT_DIR}/infra-components/sqs/definition.yaml"
kubectl apply -f "${SCRIPT_DIR}/infra-components/sqs/composition.yaml"

# Install VPC XRD and Composition
kubectl apply -f "${SCRIPT_DIR}/infra-components/vpc/definition.yaml"
kubectl apply -f "${SCRIPT_DIR}/infra-components/vpc/composition.yaml"

printInfo "+++ Apply service package: service = ${SERVICE} +++"
printInfo "+++ Apply service XRD and Compositions +++"

# Install service infrastructure XRD and Composition
kubectl apply -f "${SCRIPT_DIR}/services/${SERVICE}/infra/definition.yaml"
kubectl apply -f "${SCRIPT_DIR}/services/${SERVICE}/infra/composition.yaml"

printInfo "+++ List XRD. +++"
kubectl get xrd

printInfo "+++ List Compositions. +++"
kubectl get compositions

printInfo "+++ Apply provider package: provider = ${PROVIDER} completed +++"

