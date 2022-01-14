# vpc resource
resource "google_compute_network" "final_vpc" {
  project                 = "gcp-project-337312"
  name                    = "final-vpc"
  auto_create_subnetworks = false
}

# Management subnet, includes nat-gateway and private VM 
resource "google_compute_subnetwork" "management" {
  name          = "management-subnet"
  ip_cidr_range = "10.0.10.0/24"
  region        = "europe-west1"
  network       = google_compute_network.final_vpc.id
}

# Restricted subnet, has a private standard GKE cluster
resource "google_compute_subnetwork" "restricted" {
  name          = "restricted-subnet"
  ip_cidr_range = "10.0.11.0/24"
  region        = "europe-west1"
  network       = google_compute_network.final_vpc.id
}

resource "google_service_account" "instance_sarvice" {
  account_id   = "instance-service-account-id"
  display_name = "final_Service_Account"
}
resource "google_project_iam_binding" "final_project" {
  project = "gcp-project-337312"
  role    = "roles/container.admin"

  members = [
    "serviceAccount:${google_service_account.instance_sarvice.email}"
  ]
}

# firewall role to allow access only through IAP
resource "google_compute_firewall" "default-fw" {
  name    = "test-firewall"
  network = google_compute_network.final_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }
  direction     = "INGRESS"
  source_ranges = ["35.235.240.0/20"]
}
