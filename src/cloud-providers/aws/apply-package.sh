#!/bin/bash

# ./apply-package.sh aws sef-unified-infra

DEBUG_MODE=false
source ../scripts/configure-shell.sh

PROVIDER=$1
SERVICE=$2

printInfo "+++ Apply provider package: provider = ${PROVIDER} +++"
printInfo "+++ Apply Common Infrastructure XRD and Compositions +++"

# Install EKS XRD and Composition
kubectl apply -f ./${PROVIDER}/infra-components/eks/definition.yaml 
kubectl apply -f ./${PROVIDER}/infra-components/eks/composition.yaml
kubectl apply -f ./${PROVIDER}/infra-components/eks/func.yaml

# Install RDS XRD and Composition
kubectl apply -f ./${PROVIDER}/infra-components/rds/definition.yaml 
kubectl apply -f ./${PROVIDER}/infra-components/rds/composition.yaml

# Install SQS XRD and Composition
kubectl apply -f ./${PROVIDER}/infra-components/sqs/definition.yaml 
kubectl apply -f ./${PROVIDER}/infra-components/sqs/composition.yaml

# Install VPC XRD and Composition
kubectl apply -f ./${PROVIDER}/infra-components/vpc/definition.yaml 
kubectl apply -f ./${PROVIDER}/infra-components/vpc/composition.yaml

printInfo "+++ Apply service package: service = ${SERVICE} +++"
printInfo "+++ Apply service XRD and Compositions +++"

# Install service infrastructure XRD and Composition
kubectl apply -f ./${PROVIDER}/services/${SERVICE}/infra/definition.yaml 
kubectl apply -f ./${PROVIDER}/services/${SERVICE}/infra/composition.yaml

# Apply claims
# kubectl apply -f ./${PROVIDER}/infra-components/claims/eks-claim.yaml
# kubectl apply -f ./${PROVIDER}/infra-components/claims/rds-claim.yaml
# kubectl apply -f ./${PROVIDER}/infra-components/claims/sqs-claim.yaml
# kubectl apply -f ./${PROVIDER}/infra-components/claims/vpc-claim.yaml

printInfo "+++ List XRD. +++"
kubectl get xrd

printInfo "+++ List Compositions. +++"
kubectl get compositions

printInfo "+++ Apply provider package: provider = ${PROVIDER} completed +++"