# private VM resource
resource "google_compute_instance" "managementinstance" {
  name         = "management-vm"
  machine_type = "e2-micro"
  zone         = "europe-west1-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    network    = google_compute_network.final_vpc.id
    subnetwork = google_compute_subnetwork.management.id
  }
  # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
  #service_account = google_service_account.instance_sa.email
  #oauth_scopes    = [
  # "https://www.googleapis.com/auth/cloud-platform"
  #]
  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.instance_sarvice.email
    scopes = ["cloud-platform"]
  }
}