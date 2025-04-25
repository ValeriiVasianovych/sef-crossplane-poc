#!/bin/bash

# Setup environment script for Crossplane AWS provider configuration
# This script handles AWS credentials setup and Crossplane secret configuration

set -e

# Constants
CREDENTIALS_FILE="$HOME/.aws/credentials"
CREDENTIALS_DIR="$(dirname "$CREDENTIALS_FILE")"
TEMP_CREDENTIALS_FILE="$HOME/.aws/aws-credentials.txt"
DEFAULT_CLUSTER_NAME="eks-incubator"

# Check required commands
for cmd in aws-nokia-login kubectl; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: Required command '$cmd' not found"
        exit 1
    fi
done

# Create AWS credentials directory if it doesn't exist
if [ ! -d "$CREDENTIALS_DIR" ]; then
    mkdir -p "$CREDENTIALS_DIR"
fi

# Get cluster name
echo -n "Enter the cluster name (default: $DEFAULT_CLUSTER_NAME): "
read -r CLUSTER_NAME

if [ -z "$CLUSTER_NAME" ]; then
    CLUSTER_NAME=$DEFAULT_CLUSTER_NAME
fi

echo "Using cluster: $CLUSTER_NAME"

# Clean old sessions
echo "Cleaning old sessions..."
echo "" > "$CREDENTIALS_FILE"

# Generate AWS credentials
echo "Generating AWS credentials..."
if ! aws-nokia-login --authentication_src azure_ad --profile "$CLUSTER_NAME" --duration-seconds 43200; then
    echo "Error: Failed to generate AWS credentials"
    exit 1
fi

# Copy and process credentials
echo "Processing credentials..."
cp "$CREDENTIALS_FILE" "$TEMP_CREDENTIALS_FILE"
sed -i '1,2d' "$TEMP_CREDENTIALS_FILE"

# Apply Crossplane provider configuration
echo "Applying configuration for providers..."
if ! kubectl apply -f ../cloud-providers/aws/providers/; then
    echo "Error: Failed to apply provider configuration"
    rm -f "$TEMP_CREDENTIALS_FILE"
    exit 1
fi

# Update Crossplane AWS secret
echo "Updating aws-secret in the crossplane-system namespace..."
kubectl delete secret aws-secret -n crossplane-system --ignore-not-found

if ! kubectl create secret generic aws-secret -n crossplane-system --from-file=creds="$TEMP_CREDENTIALS_FILE"; then
    echo "Error: Failed to create aws-secret"
    rm -f "$TEMP_CREDENTIALS_FILE"
    exit 1
fi

# Cleanup
echo "Cleaning up temporary files..."
rm -f "$TEMP_CREDENTIALS_FILE"

echo "Environment setup completed successfully!"

