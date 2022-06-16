resource "argocd_application" "applications" {
  for_each = toset(var.argocd_app_names)
  metadata {
    name      = "${each.key}-${local.name_suffix}"
    namespace = var.argocd_namespace
    labels = {
      region = var.region
      env    = var.project_environment
      loc    = var.project_region
      owner  = var.service_owner
      layer  = "product"
    }
  }
  wait = true

  spec {
    project = var.argocd_project
    source {
      repo_url        = var.helm_chart_url
      path            = "${local.project_environment}/${local.project_region}/manifests/${each.key}/"
      target_revision = var.helm_chart_revision
      helm {
        value_files = ["values.yaml"]
      }
    }

    destination {
      server    = var.kubernetes_server_url
      namespace = var.product_namespace
    }
    sync_policy {
      automated = {
        prune       = true
        self_heal   = true
        allow_empty = false
      }
      retry {
        backoff = {
          duration     = ""
          max_duration = ""
        }
        limit = "0"
      }
    }
  }
}

resource "argocd_application" "tfe-operator" {
  count = var.enable_tfe_operator ? 1 : 0
  depends_on = [
    kubernetes_secret.tfe-token,
    kubernetes_secret.tfe-workspace
  ]
  metadata {
    name      = "tfe-operator-${local.name_suffix}"
    namespace = var.argocd_namespace
    labels = {
      region = var.region
      env    = var.project_environment
      loc    = var.project_region
      owner  = var.service_owner
      layer  = "operator"
    }
  }
  wait = true

  spec {
    project = var.argocd_project
    source {
      repo_url        = "https://helm.releases.hashicorp.com"
      chart           = "terraform"
      target_revision = var.tfe_operator_helm_chart_version
    }

    destination {
      server    = var.kubernetes_server_url
      namespace = var.product_namespace
    }

    sync_policy {
      automated = {
        prune       = true
        self_heal   = true
        allow_empty = false
      }
      retry {
        backoff = {
          duration     = ""
          max_duration = ""
        }
        limit = "0"
      }
    }
  }
}

resource "argocd_application" "product-infra-workspaces" {
  depends_on = [
    argocd_application.tfe-operator,
  ]
  for_each = toset(var.terraform_argocd_apps)
  metadata {
    name      = "${each.key}-infrastructure-${local.name_suffix}"
    namespace = var.argocd_namespace
    labels = {
      region = var.region
      env    = var.project_environment
      loc    = var.project_region
      owner  = var.service_owner
      layer  = "infra"
    }
  }
  wait = true

  spec {
    project = var.argocd_project
    source {
      repo_url        = var.helm_chart_url
      path            = "${local.project_environment}/${local.project_region}/infrastructure/${each.key}"
      target_revision = "main"
      helm {
        value_files = ["values.yaml"]
      }
    }

    destination {
      server    = var.kubernetes_server_url
      namespace = var.product_namespace
    }

    sync_policy {
      automated = {
        prune       = true
        self_heal   = true
        allow_empty = false
      }
      retry {
        backoff = {
          duration     = ""
          max_duration = ""
        }
        limit = "0"
      }
    }
  }
}
