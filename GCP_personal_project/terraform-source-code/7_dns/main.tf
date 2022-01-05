data "google_compute_global_address" "global_address" {
  name = "bts-ingress"
}

resource "google_dns_managed_zone" "primary" {
  name        = "hybrid"
  dns_name    = "hybridbts.net."
  description = "dns for web server"
}

resource "google_dns_record_set" "a_hybrid" {
  name = google_dns_managed_zone.primary.dns_name
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.primary.name

  rrdatas = [data.google_compute_global_address.global_address.address]
}

resource "google_dns_record_set" "cname_hybrid" {
  name = "www.${google_dns_managed_zone.primary.dns_name}"
  type = "CNAME"
  ttl  = 300

  managed_zone = google_dns_managed_zone.primary.name

  rrdatas = [google_dns_managed_zone.primary.dns_name]
}
