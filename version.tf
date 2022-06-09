terraform {
  required_version = ">= 1.0.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.6.1"
    }
    argocd = {
      source  = "oboukili/argocd"
      version = ">= 3.0.1"
    }
  }
}
