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

variable "argocd_applications" {
  description = "The names of the argocd applications"
  type        = list(any)
}

variable "gitops_repo_url" {
  description = "The repository url of the Helm chart"
  type        = string
}

variable "gitops_revision" {
  description = "The git tag for the desired version of the helm chart"
  type        = string
  default     = "main"
}

variable "container_registry_credentials" {
  description = "Credentials for the container registry so that k8s can pull application images"
  type        = string
}

# Used by terraform operator
variable "enable_tfe_operator" {
  description = "Flag to enable the terraform kubernetes operator"
  type        = bool
  default     = true
}

variable "tfe_operator_access_token" {
  description = "Terraform Cloud access token for the Kubernetes operator"
  type        = string
}

variable "tfe_operator_helm_chart_version" {
  description = "Terraform Operator Helm Chart version"
  default     = "1.1.0"
  type        = string
}

variable "terraform_argocd_apps" {
  description = "The argocd driven terraform applications"
  type        = list(any)
}

# Used by terraform operator
variable "aws_target_role_arn" {
  description = "The role arn terraform requires to assume to create resources in AWS"
  type        = string
}
variable "aws_session_name" {
  description = "The session_name terraform requires to assume a role to create resources in AWS"
  type        = string
}
variable "aws_target_external_id" {
  description = "The external id terraform requires to assume a role to create resources in AWS"
  type        = string
}
variable "tfe_ssh_key_id" {
  description = "The SSH key id registered with TFE to clone private git repos"
  type        = string
}

variable "namespace_labels" {
  description = "Labels to be applied to the namespace. Mainly used for Istio CNI"
  type        = map(string)
  default = {
    "istio.io/rev" = "1-13-2"
  }
}

variable "create_terraform_operator_egress" {
  description = "Flag to create istio egress for terraform operator"
  type        = bool
  default     = false
}
