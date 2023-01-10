data "aws_availability_zones" "available" {
  state = "available"
}

data "kubernetes_service" "service_ingress" {
  metadata {
    name      = "istio-ingressgateway"
    namespace = "istio-system"
  }
}