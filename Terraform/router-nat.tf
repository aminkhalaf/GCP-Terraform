# Router and nat-gateway
resource "google_compute_router" "final_router" {
  name    = "final-router"
  region  = google_compute_subnetwork.management.region
  network = google_compute_network.final_vpc.id

  bgp {
    asn = 64514
  }
}
resource "google_compute_router_nat" "final_nat_gateway" {
  name                               = "final-router-nat"
  router                             = google_compute_router.final_router.name
  region                             = google_compute_router.final_router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.management.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}