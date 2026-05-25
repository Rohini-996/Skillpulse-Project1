# -----------------------------
# ArgoCD Namespace
# -----------------------------
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

# -----------------------------
# Monitoring Namespace
# -----------------------------
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

# -----------------------------
# Install ArgoCD
# -----------------------------
resource "helm_release" "argocd" {

  name       = "argocd"
  namespace  = "argocd"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  depends_on = [
    kubernetes_namespace.argocd
  ]
}

# -----------------------------
# ArgoCD NodePort Service
# -----------------------------
resource "kubernetes_service" "argocd_nodeport" {

  metadata {
    name      = "argocd-server-nodeport"
    namespace = "argocd"
  }

  spec {

    selector = {
      "app.kubernetes.io/name" = "argocd-server"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 8080
      node_port   = 30081
    }

    type = "NodePort"
  }

  depends_on = [
    helm_release.argocd
  ]
}

# -----------------------------
# Install Prometheus + Grafana
# -----------------------------
resource "helm_release" "kube_prometheus_stack" {

  name       = "kube-prometheus-stack"
  namespace  = "monitoring"

  repository = "https://prometheus-community.github.io/helm-charts"

  chart = "kube-prometheus-stack"

  depends_on = [
    kubernetes_namespace.monitoring
  ]

  values = [
    <<EOF

grafana:
  service:
    type: NodePort
    nodePort: 30300

prometheus:
  service:
    type: NodePort
    nodePort: 30090

EOF
  ]
}
