resource "google_compute_network" "vpc_project" {
  project                 = "gcp-project-337312"
  name                    = "vpc-gcp"
  auto_create_subnetworks = false
  mtu                     = 1460
}