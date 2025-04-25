#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AWS_PROVIDERS_DIR="$SCRIPT_DIR/../cloud-providers/aws/providers"

CREDENTIALS_FILE="$HOME/.aws/credentials"
TEMP_CREDENTIALS_FILE="$HOME/.aws/aws-credentials.txt"
DEFAULT_CLUSTER_NAME="eks-incubator"

echo -n "Enter the cluster name (default: $DEFAULT_CLUSTER_NAME): "
read CLUSTER_NAME

if [ -z "$CLUSTER_NAME" ]; then
  CLUSTER_NAME=$DEFAULT_CLUSTER_NAME
fi

echo "Using cluster: $CLUSTER_NAME"

echo "Cleaning old sessions..."
echo "" > "$CREDENTIALS_FILE"

echo "Generating AWS credentials..."
aws-nokia-login --authentication_src azure_ad --profile "$CLUSTER_NAME" --duration-seconds 43200

cp "$CREDENTIALS_FILE" "$TEMP_CREDENTIALS_FILE"
sed -i '1,2d' "$TEMP_CREDENTIALS_FILE"

# Проверка существования файлов
if [ ! -f "$AWS_PROVIDERS_DIR/provider-config.yaml" ] || [ ! -f "$AWS_PROVIDERS_DIR/providers.yaml" ]; then
  echo "Error: Provider config files not found in $AWS_PROVIDERS_DIR"
  exit 1
fi

echo "Applying configuration for providers..."
kubectl apply -f "$AWS_PROVIDERS_DIR/provider-config.yaml"
kubectl apply -f "$AWS_PROVIDERS_DIR/providers.yaml"

echo "Deleting old aws-secret (if any)..."
kubectl delete secret aws-secret -n crossplane-system --ignore-not-found

echo "Creating a new aws-secret in the crossplane-system namespace..."
kubectl create secret generic aws-secret -n crossplane-system --from-file=creds="$TEMP_CREDENTIALS_FILE"

echo "Environment setup completed."

