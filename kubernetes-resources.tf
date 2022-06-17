# TODO: Rename this to product
resource "kubernetes_namespace" "offering" {
  metadata {
    name   = var.product_namespace
    labels = var.namespace_labels
  }
}

# Create secret to allow kubernetes to access terraform cloud
resource "kubernetes_secret" "tfe-token" {
  metadata {
    name      = "terraformrc"
    namespace = var.product_namespace
  }

  data = {
    "credentials" = "credentials app.terraform.io {token = \"${var.tfe_operator_access_token}\"}"
  }
  type = "Opaque"
}


# Create secret to populate tfc workspaces created by the operator with sensitive values
resource "kubernetes_secret" "tfe-workspace" {
  metadata {
    name      = "workspacesecrets"
    namespace = var.product_namespace
  }

  data = {
    aws_target_role_arn    = var.aws_target_role_arn
    aws_session_name       = var.aws_session_name
    aws_target_external_id = var.aws_target_external_id
  }
  type = "Opaque"
}

# Create config-map with non-sensitive terraform outputs for the tfe workspace
resource "kubernetes_config_map" "tf-output" {
  metadata {
    name = "tf-output-${var.project}-${local.name_suffix}"
  }

  data = {
    tfe_ssh_key_id = var.tfe_ssh_key_id
  }
}

# Create secret to allow kubernetes access to the Container Registry
resource "kubernetes_secret" "container-registry-secret" {
  metadata {
    name      = "dockerconfigjson-ghcr"
    namespace = var.product_namespace
  }

  data = {
    ".dockerconfigjson" = var.container_registry_credentials
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "kubernetes_manifest" "terraform-operator-egress" {
  manifest = {
    "apiVersion" = "networking.istio.io/v1beta1"
    "kind"       = "ServiceEntry"
    "metadata" = {
      "name"      = "terraform-operator"
      "namespace" = "istio-system"
    }
    "spec" = {
      "hosts" = [
        "app.terraform.io",
        "archivist.terraform.io",
      ]
      "location" = "MESH_EXTERNAL"
      "ports" = [
        {
          "name" = "https",
          "number" = 443
          "protocol" = "HTTPS"
        }
      ]
      "resolution" = "DNS"
    }
  }
}
