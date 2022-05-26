variable "region" {
  description = "Cloud provider region name"
  type        = string
}

variable "project_environment" {
  description = "Business name of Kidsloop environment (e.g. test)"
  type        = string
}

variable "project_region" {
  description = "Business name of Kidsloop region (e.g. uk/in/id/vn etc)"
  type        = string
}

variable "service_owner" {
  description = "Owner of deployment (which team manages?)"
  type        = string
}

variable "project" {
  description = "The Project name"
  type        = string
  default     = "data-services"
}

variable "tags" {
  description = "Any additional tags to add to resources deployed by this stack."
  type        = map(any)
  default     = {}
}

variable "domain" {
  description = "The name of the domain which will be used to host the Kidsloop environment (not including any microservice-specific parts)."
  type        = string
}

# Kubernetes inputs
variable "kubernetes_server_url" {
  description = "The url for the target cluster"
  type        = string
}

variable "eks_oidc_provider_arn" {
  description = "ARN of AWS EKS OIDC IAM provider (for IAM policies)"
  type        = string
}

variable "eks_oidc_provider_id" {
  description = "ID of AWS EKS OIDC IAM provider (for IAM policies)"
  type        = string
}

variable "service_account_name" {
  description = "Service account name in Kubernetes"
  type        = string
  default     = "data-services-sa"
}

variable "product_namespace" {
  description = "The kubernetes namespace which the product will be deployed to"
  type        = string
}

# Logging inputs
variable "logs_bucket_id" {
  description = "ID of logs bucket"
  type        = string
}

# ArgoCD
variable "argocd_namespace" {
  description = "The kubernetes namespace which the argocd resources live"
  type        = string
  default     = "argocd"
}

variable "argocd_project" {
  description = "The name of the argocd project"
  type        = string
  default     = "data-services"
}

variable "helm_chart_url" {
  description = "The repository url of the Helm chart"
  type        = string
}

variable "microgateway_helm_chart_revision" {
  description = "The git tag for the desired version of the helm chart"
  type        = string
  default     = "main"
}

variable "istio_helm_chart_revision" {
  description = "The git tag for the desired version of the helm chart"
  type        = string
  default     = "main"
}

variable "container_registry_credentials" {
  description = "Credentials for the container registry so that k8s can pull application images"
  type        = string
  sensitive   = true
}