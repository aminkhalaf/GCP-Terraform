resource "google_compute_subnetwork" "private1-subnetwork" {
  name          = "management-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "europe-west1"
  network       = google_compute_network.vpc_project.name
  }