resource "helm_release" "webapp1" {
  name  = "webapp1"
  repository       = "./helm"
  chart            = "webapp1"
  namespace        = "webapps"
  version          = "1.0.0"
  create_namespace = true

#   values = [
#     file("webapp1/values.yaml")
#   ]
}


resource "helm_release" "webapp2" {
  name  = "webapp2"
  repository       = "./helm"
  chart            = "webapp2"
  namespace        = "webapps"
  version          = "1.0.0"
  create_namespace = true


}




