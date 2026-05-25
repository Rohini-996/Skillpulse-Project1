output "argocd_namespace" {
  value = kubernetes_namespace.argocd.metadata[0].name
}

output "argocd_helm_release" {
  value = helm_release.argocd.name
}

output "argocd_access_command" {
  value = "kubectl port-forward svc/argocd-server -n argocd 8080:443 --address=0.0.0.0"
}

output "argocd_password_command" {
  value = "kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}' | base64 -d && echo"
}
