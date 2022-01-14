
# k8s cluster
resource "google_container_cluster" "final_cluster" {
  name       = "final-gke-cluster"
  location   = "europe-west1"
  network    = google_compute_network.final_vpc.id
  subnetwork = google_compute_subnetwork.restricted.id
  
  private_cluster_config {
    master_ipv4_cidr_block  = "172.16.0.0/28"
    enable_private_nodes    = true
    enable_private_endpoint = true
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "10.0.10.0/24"
    }
  }
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "/21"
    services_ipv4_cidr_block = "/21"
  }

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_service_account" "cluster_sarvice" {
  account_id   = "service-account-id"
  display_name = "Service Account"
}
resource "google_project_iam_binding" "final_iam_cluster" {
  project = "gcp-project-337312"
  role    = "roles/container.admin"

  members = [
    "serviceAccount:${google_service_account.cluster_sarvice.email}"
  ]
}

resource "google_container_node_pool" "final_nodes" {
  name       = "final-node-pool"
  location   = "europe-west1"
  cluster    = google_container_cluster.final_cluster.name
  node_count = 1

  node_config {
    preemptible  = false
    machine_type = "e2-micro"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.cluster_sarvice.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
