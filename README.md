# Azure Kubernetes CI/CD Flow

## Introduction

This repository provides an end-to-end solution for automating Continuous Integration and Continuous Deployment (CI/CD) in a Kubernetes environment on Azure. It leverages Terraform for infrastructure as code, Docker for containerization, Helm for package management, and includes Jenkins pipeline configurations for CI/CD workflows.

## Getting Started

### Prerequisites

- Terraform 
- Azure CLI
- Docker
- Helm
- Kubernetes CLI (kubectl)

### Clone the Repository

To clone the repository, run the following command:

```
git clone https://github.com/manikcloud/AzureK8s-CICD-Flow
```

### Deployment Steps

1. **Initialize Terraform**: Navigate to the `terraform-root` directory to initialize and apply the Terraform configuration:


```
git clone https://github.com/manikcloud/Azure-k8s-infra-ops/
```
    ```

    cd Azure-k8s-infra-ops/terraform
    terraform init
    terraform apply
    ```

2. **Build Docker Images**: You can build the Docker images from the `images` directory:

    ```

    cd ../images
    docker build -t your-image-name .
    ```

3. **Deploy Helm Chart**: To deploy Helm charts, go to the `golden-chart` directory and run:

    ```

    helm install your-release-name .
    ```

4. **Apply RBAC Configurations**: Navigate to `rbac-permission` and apply the YAML configuration:

    ```

    kubectl apply -f sa-permission.yaml
    ```

### Directory and File Summary

- `app_values`: Contains value files (`values.yaml`) for specific applications like `java-calc` and `service`.
  
- `golden-chart`: Houses the Golden Helm chart along with templates and value files, standardizing Kubernetes deployments.

- `images`: Contains Dockerfiles for building various images, such as devops-tools, Docker images for Debian, and Maven.

- `rbac-permission`: Scripts and YAML configurations to set up Kubernetes RBAC permissions.

- `resources`: Additional resource configurations like `pod.yaml`.

- `vars`: Houses Jenkinsfile configurations for both Continuous Integration (`ci-Jenkinsfile`) and Continuous Deployment (`cd-Jenkinsfile`).

## CI/CD Integration

When code is pushed to this repository, it triggers the CI/CD pipeline hosted in [AzureK8s-CICD-Flow](https://github.com/manikcloud/AzureK8s-CICD-Flow). The pipeline takes care of building the application, running tests, and deploying it to the Kubernetes cluster.

### Linked Repositories

1. **Infrastructure**: The [Azure-k8s-infra-ops](https://github.com/manikcloud/Azure-k8s-infra-ops/) repository contains Terraform scripts to provision the infrastructure components like VNet, AKS, and ACR in Azure.
  
2. **CI/CD Pipeline**: The [AzureK8s-CICD-Flow](https://github.com/manikcloud/AzureK8s-CICD-Flow) repository hosts the CI/CD pipeline, which builds, tests, and deploys this application.

### Development Story

The development process starts with infrastructure setup using [Azure-k8s-infra-ops](https://github.com/manikcloud/Azure-k8s-infra-ops/). Once the infrastructure is provisioned, code pushes to this repository trigger the CI/CD pipeline in [AzureK8s-CICD-Flow](https://github.com/manikcloud/AzureK8s-CICD-Flow).


## Features

### Terraform Automation
Automatically provision a 3-tier Virtual Network (VNet), Azure Container Registry (ACR), and Azure Kubernetes Service (AKS) in Azure.

### Docker Images
Dockerfiles for various devops tools are included, allowing you to build and manage containers for your applications and services easily.

### Helm Charts
Golden Helm chart templates and application-specific value files to standardize and simplify the deployment of Kubernetes applications.

### RBAC Permissions
Scripts and YAML configurations to set up Role-Based Access Control (RBAC) permissions in your Kubernetes cluster.

### Jenkins Pipelines
CI/CD pipelines configured through Jenkinsfiles that handle building, testing, and deploying your applications.

## CI/CD Flow Overview

1. **Continuous Integration**: Code from your repository is automatically pulled, built into Docker images, and pushed to ACR.
  
2. **Automated Testing**: After successful image build, automated tests are run against it. 

3. **Deployment Preparation**: Helm charts are populated with specific `values.yaml` files tailored for the application.

4. **Continuous Deployment**: If all tests pass, the Docker image is deployed to the AKS cluster using Helm charts.

5. **RBAC and Security**: Access permissions to the AKS cluster are managed through Kubernetes RBAC, controlled by scripts and YAML configurations.

6. **Monitoring and Logging**: Azure's native monitoring solutions can be used to keep track of your applications and services running in AKS.

