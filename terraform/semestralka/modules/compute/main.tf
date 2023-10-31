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

data "openstack_compute_flavor_v2" "flavor_1" {
  name = "1c05r8d"
}

data "openstack_images_image_v2" "ubuntu" {
  name = "ubuntu-22.04-KIS"
}

# data "openstack_images_image_v2" "debian" {
#   name = "debian-12-kis"
# }

resource "openstack_networking_secgroup_v2" "security_group" {
  name        = "${var.project}-${var.environment}-secgroup"
  description = "Managed by Terraform!"
}

# Allow ICMP from University network
resource "openstack_networking_secgroup_rule_v2" "security_group_rule_university_icmp" {
  description       = "Managed by Terraform!"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = local.university.network.cidr
  security_group_id = openstack_networking_secgroup_v2.security_group.id
}

# Allow ICMP from your public IP address
resource "openstack_networking_secgroup_rule_v2" "security_group_rule_icmp" {
  description       = "Managed by Terraform!"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = join("/", [var.my_public_ip, "32"])
  security_group_id = openstack_networking_secgroup_v2.security_group.id
}

# Allow UDP from your public IP address
resource "openstack_networking_secgroup_rule_v2" "security_group_rule_udp" {
  description       = "Managed by Terraform!"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  remote_ip_prefix  = join("/", [var.my_public_ip, "32"])
  security_group_id = openstack_networking_secgroup_v2.security_group.id
}

# Allow ALL TCP from your public IP address
resource "openstack_networking_secgroup_rule_v2" "security_group_rule_tcp" {
  description       = "Managed by Terraform!"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = join("/", [var.my_public_ip, "32"])
  security_group_id = openstack_networking_secgroup_v2.security_group.id
}

resource "openstack_compute_instance_v2" "jump_server" {
  name            = "${var.project}-${var.environment}-jump-server"
  image_id        = data.openstack_images_image_v2.ubuntu.id
  flavor_id       = data.openstack_compute_flavor_v2.flavor_1.id
  key_pair        = var.key_pair_name
  security_groups = [openstack_networking_secgroup_v2.security_group.name]

  # user_data = var.user_data

  network {
    name = var.network_name
  }
}

resource "openstack_compute_interface_attach_v2" "jump_interface_private" {
  instance_id = openstack_compute_instance_v2.jump_server.id
  network_id  = openstack_networking_network_v2.siet.id
}

resource "openstack_compute_instance_v2" "server_private" {
  name            = "${var.project}-${var.environment}-instance_private"
  image_id        = data.openstack_images_image_v2.ubuntu.id
  flavor_id       = data.openstack_compute_flavor_v2.flavor_1.id
  key_pair        = var.key_pair_name
  security_groups = [openstack_networking_secgroup_v2.security_group.name]

  user_data = var.user_data
  
  network {
    name = openstack_networking_network_v2.siet.name
  }
}

resource "openstack_compute_interface_attach_v2" "server_interface_private" {
  instance_id = openstack_compute_instance_v2.server_private.id
  network_id  = data.openstack_networking_network_v2.public_network.id
}

# Router nán nefunguje namiesto neho máme ako jump server
# resource "openstack_networking_router_interface_v2" "jump_interface" {
#   router_id = openstack_networking_network_v2.public_network.id
#   subnet_id = openstack_networking_subnet_v2.subnet_private.id
# }

# resource "openstack_networking_router_v2" "router" {
#   name                = var.router_name
#   admin_state_up      = true
#   external_network_id = data.openstack_networking_network_v2.public_network.id
# }

# resource "openstack_networking_router_interface_v2" "router_interface" {
#   router_id = openstack_networking_router_v2.router.id
#   subnet_id = openstack_networking_subnet_v2.subnet_private.id
# }

