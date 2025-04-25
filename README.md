# Crossplane AWS Resource Configuration

This repository contains the full configuration for creating resources in AWS using **Crossplane** technology and its abstractions: **Composition, CRD, Claim**.

The project includes examples of both simple resource creation and more advanced usage of Crossplane with abstractions for convenient infrastructure management.

## 📂 Repository Structure

- **`providers/`** - contains the full configuration file of providers used in the current configurations.
- **`examples/`** - examples of creating AWS resources using a simple declarative Crossplane approach.
- **`resources/`** - main configuration files, divided by abstraction.

## `resources/` Directory

Configuration files are divided by resources:

```
├── resources
│   ├── eks
│   │   ├── composition.yaml      # Composition for EKS
│   │   ├── definition.yaml       # CRD definition for EKS
│   │   └── func.yaml             # Processing functions
│   ├── eks-claim.yaml            # Claim for EKS
│   ├── rds
│   │   ├── composition.yaml      # Composition for RDS
│   │   └── definition.yaml       # CRD definition for RDS
│   ├── rds-claim.yaml            # Claim for RDS
│   ├── sqs
│   │   ├── composition.yaml      # Composition for SQS
│   │   └── definition.yaml       # CRD definition for SQS
│   ├── sqs-claim.yaml            # Claim for SQS
│   ├── vpc
│   │   ├── composition.yaml      # Composition for VPC
│   │   └── definition.yaml       # CRD definition for VPC
│   └── vpc-claim.yaml            # Claim for VPC
└── setup-env.sh                  # Environment setup script
```

## How to Use

1. **Install Crossplane** (if not installed):
   ```sh
   kubectl apply -f https://raw.githubusercontent.com/crossplane/crossplane/master/install.sh | sh
   ```

2. **Configure the AWS provider**:
   ```sh
   kubectl apply -f providers/
   ```

3. **Apply the resource configuration**:
   ```sh
   kubectl apply -f resources/
   ```

4. **Check the created resources**:
   ```sh
   kubectl get managed
   ```

## Useful Links
- [Crossplane Documentation](https://crossplane.io/docs/latest/)
- [Crossplane AWS Provider](https://github.com/crossplane/provider-aws)




