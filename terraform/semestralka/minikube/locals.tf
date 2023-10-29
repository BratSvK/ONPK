# --- root/locals.tf ---

locals {
  kis_os_url         = "https://158.193.152.44"
  kis_os_auth_url    = "${local.kis_os_url}:5000/v3/"
  kis_os_region      = "RegionOne"
  kis_os_domain_name = "admin_domain"
  kis_os_endpoint_overrides = {
    compute = "${local.kis_os_url}:8774/v2.1/"
    image   = "${local.kis_os_url}:9292/v2.0/"
    network = "${local.kis_os_url}:9696/v2.0/"
  }
  kis_os_cidr = "10.0.0.0/20"
  kis_ext_cidr = "0.0.0.0/0"  # Allow ICMP from any source
  university = {
    network = {
      cidr = "158.193.0.0/16" # zistit svoju ip adresu
    }
  }
  
  my_public_ip = "${data.http.my_public_ip.response_body}/32"
  project      = lower("${var.tenant_name}-minikube")
}