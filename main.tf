# main.tf

provider "kubernetes" {
  config_path = "~/.kube/config"  # Adjust the path to your Kubernetes config file
}

# Deploy the 'my-go-app' Deployment
resource "kubernetes_deployment" "my-go-app" {
  metadata {
    name = "my-go-app"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "my-go-app"
      }
    }

    template {
      metadata {
        name = "my-go-app"
        labels = {
          app = "my-go-app"
        }
      }

      spec {
        container {
          name  = "my-go-app"
          image = "behramkhanzada/go-postgres:v1"

          env {
            name  = "DB_HOST"
            value = "postgres"
          }

          env {
            name  = "DB_NAME"
            value = "my_pgdb"
          }

          env {
            name  = "DB_PASSWORD"
            value = "alpha123"
          }

          env {
            name  = "DB_PORT"
            value = "5432"
          }

          env {
            name  = "DB_SSL_MODE"
            value = "disable"
          }

          env {
            name  = "DB_USER"
            value = "postgres"
          }

          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

# Deploy the 'my-go-app' Service
resource "kubernetes_service" "my-go-app" {
  metadata {
    name = "my-go-app"
  }

  spec {
    port {
      name       = "http"
      port       = 8081
      target_port = 8080
    }

    selector = {
      app = "my-go-app"
    }
  }
}

# Deploy the 'postgres-data-tf' PersistentVolumeClaim
resource "kubernetes_persistent_volume_claim" "postgres-data-tf" {
  metadata {
    name = "postgres-data-tf"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "100Mi"
      }
    }
  }
}

# Deploy the 'postgres' Deployment
resource "kubernetes_deployment" "postgres" {
  metadata {
    name = "postgres-tf"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "postgres"
      }
    }

    template {
      metadata {
        name = "postgres"
        labels = {
          app = "postgres"
        }
      }

      spec {
        container {
          name  = "postgres"
          image = "postgres:latest"

          env {
            name  = "POSTGRES_DB"
            value = "my_pgdb"
          }

          env {
            name  = "POSTGRES_PASSWORD"
            value = "alpha123"
          }

          env {
            name  = "POSTGRES_USER"
            value = "postgres"
          }

          port {
            container_port = 5432
          }

                   volume_mount {
            mount_path = "/var/lib/postgresql/data"
            name       = "postgres-data-tf"
          }
        }

        volume {
          name = "postgres-data-tf"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.postgres-data-tf.metadata[0].name
          }

          
        }
      }
    }
  }
}

# Deploy the 'postgres' Service
resource "kubernetes_service" "postgres" {
  metadata {
    name = "postgres"
  }

  spec {
    port {
      name       = "5432"
      port       = 5432
      target_port = 5432
    }

    selector = {
      app = "postgres"
    }
  }
}
