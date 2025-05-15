#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../scripts/configure-shell.sh"

PROVIDER=$1
SERVICE=$2

printInfo "--- Deleting service package: service = ${SERVICE} ---"
printInfo "--- Deleting service Claim, Compositions, and XRD ---"

# Delete service infrastructure Claim, Composition, and Definition
kubectl delete -f "${SCRIPT_DIR}/services/${SERVICE}/infra/claim.yaml" --ignore-not-found
kubectl delete -f "${SCRIPT_DIR}/services/${SERVICE}/infra/composition.yaml" --ignore-not-found
kubectl delete -f "${SCRIPT_DIR}/services/${SERVICE}/infra/definition.yaml" --ignore-not-found

printInfo "--- Deleting Common Infrastructure XRD and Compositions ---"

# Delete VPC XRD and Composition
kubectl delete -f "${SCRIPT_DIR}/infra-components/vpc/composition.yaml" --ignore-not-found
kubectl delete -f "${SCRIPT_DIR}/infra-components/vpc/definition.yaml" --ignore-not-found

# Delete SQS XRD and Composition
kubectl delete -f "${SCRIPT_DIR}/infra-components/sqs/composition.yaml" --ignore-not-found
kubectl delete -f "${SCRIPT_DIR}/infra-components/sqs/definition.yaml" --ignore-not-found

# Delete RDS XRD and Composition
kubectl delete -f "${SCRIPT_DIR}/infra-components/rds/composition.yaml" --ignore-not-found
kubectl delete -f "${SCRIPT_DIR}/infra-components/rds/definition.yaml" --ignore-not-found

# Delete EKS XRD and Composition
kubectl delete -f "${SCRIPT_DIR}/infra-components/eks/func.yaml" --ignore-not-found
kubectl delete -f "${SCRIPT_DIR}/infra-components/eks/composition.yaml" --ignore-not-found
kubectl delete -f "${SCRIPT_DIR}/infra-components/eks/definition.yaml" --ignore-not-found

printInfo "--- Cleanup completed for provider = ${PROVIDER}, service = ${SERVICE} ---"

