terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.3"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}


resource "kubernetes_deployment" "app_deployment" {
  metadata {
    name = "app-deployment"
  }

  spec {
    selector {
      match_labels = {
        app = "my-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "my-app"
        }
      }

      spec {
        container {
          image = "shivangti/my-flask-app:v2"
          name  = "my-app"

          port {
            container_port = 5000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app_service" {
  metadata {
    name = "app-service"
  }

  spec {
    selector = {
      app = "my-app"
    }

    port {
      port        = 8081
      target_port = 5000
    }
    type = "NodePort"
  }
}
