# --- GKE CLUSTER (The Control Plane) ---
resource "google_container_cluster" "primary" {
  name     = "node-app-cluster"
  location = "us-central1-a" # Zonal cluster (cheaper/simpler than Regional)
  
  # We reference the Network/Subnet we created in Lesson 1
  network    = google_compute_network.vpc_network.id
  subnetwork = google_compute_subnetwork.subnet.id

  # We can't create a cluster with no nodes, but we want to manage them
  # separately. So we create a default pool, then immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1  
  
  # Best Practice: Workload Identity (allows Pods to talk to GCP APIs securely)
  workload_identity_config {
    workload_pool = "${data.google_client_config.default.project}.svc.id.goog"
  }
}

# --- NODE POOL (The Workers) ---
resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  location   = "us-central1-a"
  cluster    = google_container_cluster.primary.name
  node_count = 1 # Number of nodes (VMs)

  node_config {
    preemptible  = true # CHEAPER! (Google can shut these down, fine for learning)
    machine_type = "e2-medium" # Small, cheap machine (2 vCPU, 4GB RAM)

    # Scopes define what GCP APIs these VMs can access.
    # We give them minimal access (monitoring/logging).
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

# Helper to get project ID dynamically
data "google_client_config" "default" {}
