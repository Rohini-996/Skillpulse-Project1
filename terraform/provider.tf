# AWS Provider (optional if using AWS resources)
provider "aws" {
  region = "us-east-1"
}

# Kubernetes Provider
provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Helm Provider
provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}
