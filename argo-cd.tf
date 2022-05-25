resource "argocd_application" "microgateway" {
  metadata {
    name      = "microgateway-${local.name_suffix}"
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
      path            = "${local.project_environment}/${local.project_region}/manifests/microgateway/"
      target_revision = var.microgateway_helm_chart_revision
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

resource "argocd_application" "istio" {
  metadata {
    name      = "istio-config-${local.name_suffix}"
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
      path            = "${local.project_environment}/${local.project_region}/manifests/istio"
      target_revision = var.istio_helm_chart_revision
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