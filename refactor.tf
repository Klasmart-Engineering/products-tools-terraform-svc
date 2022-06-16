moved {
  from = argocd_application.istio
  to   = argocd_application.applications["istio-config"]
}
moved {
  from = argocd_application.microgateway
  to   = argocd_application.applications["microgateway"]
}
