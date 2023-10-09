# --- main.tf ---

resource "openstack_networking_network_v2" "siet" {
  name           = var.username   #meno siete take ake mame v Openstacku
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_private" {
  network_id = openstack_networking_network_v2.siet.id
  cidr       = local.kis_os_cidr
}

data "openstack_networking_network_v2" "public_network" {
  name = var.network_name
}

resource "openstack_networking_router_v2" "router" {
  name                = var.router_name
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.public_network.id
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.subnet_private.id
}

resource "openstack_networking_secgroup_v2" "secgroup_1" {
  name        = "secgroup_office"
  description = "My router security group"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = local.kis_ext_cidr
  security_group_id = openstack_networking_secgroup_v2.secgroup_1.id
}