#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../scripts/configure-shell.sh"

PROVIDER=$1
SERVICE=$2

printInfo "+++ Delete provider package: provider = ${PROVIDER} +++"
printInfo "+++ Delete Common Infrastructure XRD and Compositions +++"

# Delete EKS XRD and Composition
kubectl delete -f ./${PROVIDER}/infra-components/eks/definition.yaml 
kubectl delete -f ./${PROVIDER}/infra-components/eks/composition.yaml
kubectl delete -f ./${PROVIDER}/infra-components/eks/func.yaml

# Delete RDS XRD and Composition
kubectl delete -f ./${PROVIDER}/infra-components/rds/definition.yaml 
kubectl delete -f ./${PROVIDER}/infra-components/rds/composition.yaml

# Delete SQS XRD and Composition
kubectl delete -f ./${PROVIDER}/infra-components/sqs/definition.yaml 
kubectl delete -f ./${PROVIDER}/infra-components/sqs/composition.yaml

# Delete VPC XRD and Composition
kubectl delete -f ./${PROVIDER}/infra-components/vpc/definition.yaml 
kubectl delete -f ./${PROVIDER}/infra-components/vpc/composition.yaml

printInfo "+++ Delete service package: service = ${SERVICE} +++"
printInfo "+++ Delete service XRD and Compositions +++"

# Delete service infrastructure XRD and Composition
kubectl delete -f ./${PROVIDER}/services/${SERVICE}/infra/definition.yaml 
kubectl delete -f ./${PROVIDER}/services/${SERVICE}/infra/composition.yaml

# Delete claims
# kubectl delete -f ./${PROVIDER}/infra-components/claims/eks-claim.yaml
# kubectl delete -f ./${PROVIDER}/infra-components/claims/rds-claim.yaml
# kubectl delete -f ./${PROVIDER}/infra-components/claims/sqs-claim.yaml
# kubectl delete -f ./${PROVIDER}/infra-components/claims/vpc-claim.yaml

printInfo "+++ List XRD. +++"
kubectl get xrd

printInfo "+++ List Compositions. +++"
kubectl get compositions

printInfo "+++ Delete provider package: provider = ${PROVIDER} completed +++"
