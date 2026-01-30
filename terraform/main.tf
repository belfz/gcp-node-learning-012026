terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  # This tells Terraform: "Don't save state locally. Save it in this bucket."
  backend "gcs" {
    bucket  = "learning-012026"  # <--- REPLACE THIS (e.g. tf-state-learning-john-99)
    prefix  = "terraform/state"
  }
}

provider "google" {
  project = "learning-012026"     # <--- REPLACE THIS (e.g. learning-gcp-node-john-99)
  region  = "us-central1"
}

# --- RESOURCES ---

# 1. The Virtual Private Cloud (VPC)
# Think of this as the walls of your data center.
resource "google_compute_network" "vpc_network" {
  name                    = "gke-network"
  auto_create_subnetworks = false # We want full control, so we say FALSE.
}

# 2. A Subnet
# A specific room in that data center.
resource "google_compute_subnetwork" "subnet" {
  name          = "gke-subnet-us-central1"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
}

# 3. Artifact Registry Repository
# This is like DockerHub, but private and hosted in your GCP project.
resource "google_artifact_registry_repository" "my_repo" {
  location      = "us-central1"
  repository_id = "node-app-repo"
  description   = "Docker repository for our Node.js app"
  format        = "DOCKER"
}
