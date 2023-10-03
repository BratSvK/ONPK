# --- main.tf ---

resource "openstack_networking_network_v2" "private_siet" {
  name           = var.username #meno siete take ake mame v Openstacku
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_private" {
  network_id = openstack_networking_network_v2.private_siet.id
  cidr       = local.kis_os_cidr
}

resource "openstack_networking_router_v2" "router_private_siet" {
  name                = var.router_name
  admin_state_up      = true                  
  external_network_id = "f67f0d72-0ddf-11e4-9d95-e1f29f417e2f"
}