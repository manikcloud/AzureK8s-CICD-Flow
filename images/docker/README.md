# Azure Kubernetes CI/CD Flow

## Introduction

This repository provides an end-to-end solution for automating Continuous Integration and Continuous Deployment (CI/CD) in a Kubernetes environment on Azure. It leverages Terraform for infrastructure as code, Docker for containerization, Helm for package management, and includes Jenkins pipeline configurations for CI/CD workflows.

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

## Getting Started

### Prerequisites

- Terraform v1.x
- Azure CLI
- Docker
- Helm
- Kubernetes CLI (kubectl)

### Clone the Repository

To clone the repository, run the following command:

```
git clone https://github.com/manikcloud/AzureK8s-CICD-Flow
```