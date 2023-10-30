resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = "istio-system"
  }
}

resource "helm_release" "istio_base" {
  name  = "istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart = "base"
  cleanup_on_fail = true
  force_update    = false
  namespace       = kubernetes_namespace.istio_system.metadata.0.name
  
  depends_on = [ aws_eks_node_group.this, kubernetes_namespace.istio_system ]
}
# Sometimes istiod gives error then upgrade it's version cross check istio-ingree version and add 2 in that and use that version in istiod
resource "helm_release" "istiod" {
  name  = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart = "istiod"
  cleanup_on_fail = true
  force_update    = false
  namespace       = kubernetes_namespace.istio_system.metadata.0.name

  set {
    name = "meshConfig.accessLogFile"
    value = "/dev/stdout"
  }


  depends_on = [ aws_eks_node_group.this,  helm_release.istio_base ]
}

resource "helm_release" "istio_ingress" {
  name  = "istio-ingress"
  #repository = "https://istio-release.storage.googleapis.com/charts"
  chart = "./istio-ingress/"  
  #cleanup_on_fail = true
  #force_update    = false
  namespace       = kubernetes_namespace.istio_system.metadata.0.name

  set {
    name = "values.gateways.istio-ingressgateway.type"
    value = "LoadBalancer"
  }

  depends_on = [ aws_eks_node_group.this,  helm_release.istiod ]
}
