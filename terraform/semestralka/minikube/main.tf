# --- root/main.tf ---

data "http" "my_public_ip" {
  url = "http://ipv4.icanhazip.com"
}

data "cloudinit_config" "user_data" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    filename     = "userdata_base"
    content      = file("${path.module}/scripts/base.sh")
  }

  part {
    content_type = "text/x-shellscript"
    filename     = "userdata_docker"
    content      = file("${path.module}/scripts/docker.sh")
  }

  part {
    content_type = "text/x-shellscript"
    filename     = "userdata_minikube"
    content      = file("${path.module}/scripts/minikube.sh")
  }
}

# resource "openstack_compute_keypair_v2" "keypair" {
#   name = "${local.project}-${var.environment}-keypair"
# }

# resource "local_file" "private_key" {
#   content         = openstack_compute_keypair_v2.keypair.private_key
#   filename        = "${path.module}/${openstack_compute_keypair_v2.keypair.name}.pem"
#   file_permission = "0400"
# }

module "instance" {
  source        = "github.com/BratSvK/ONPK/terraform/semestralka/modules/compute"
  project       = var.project
  password      = var.password
  username      = var.username
  tenant_name   = var.tenant_name
  environment   = var.environment
  network_name  = var.network_name
  router_name   = var.router_name
  key_pair_name = var.key_pair_name
  my_public_ip  = data.http.my_public_ip.response_body
  user_data     = data.cloudinit_config.user_data.rendered
}