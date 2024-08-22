resource "openstack_networking_router_v2" "talos-router" {
    name                = "talos-router"
    admin_state_up      = true
    external_network_id = data.openstack_networking_network_v2.public-network.id
}

resource "openstack_networking_router_interface_v2" "talos-router-interface" {
    router_id = openstack_networking_router_v2.talos-router.id
    subnet_id = openstack_networking_subnet_v2.talos-subnet-1.id
}

resource "openstack_networking_network_v2" "talos" {
    name = "talos-network"
    admin_state_up = true
}

resource "openstack_networking_subnet_v2" "talos-subnet-1" {
    name = "talos-subnet-1"
    network_id = openstack_networking_network_v2.talos.id
    cidr = "192.168.1.0/24"
}

resource "openstack_networking_secgroup_v2" "talos-controlplane" {
    name        = "talos"
    description = "A Security Group for Talos Linux"
}

resource "openstack_networking_secgroup_v2" "talos-workers" {
    name        = "talos-workers"
    description = "A Security Group for Talos Linux workers"
}

resource "openstack_networking_secgroup_rule_v2" "k8s-api" {
    direction = "ingress"
    ethertype = "IPv4"
    protocol  = "tcp"
    port_range_min = 6443
    port_range_max = 6443
    remote_ip_prefix = "0.0.0.0/0"
    security_group_id = openstack_networking_secgroup_v2.talos-controlplane.id
}

resource "openstack_networking_secgroup_rule_v2" "talos-apid-controlplane" {
    direction = "ingress"
    ethertype = "IPv4"
    protocol  = "tcp"
    port_range_min = 50000
    port_range_max = 50000
    remote_ip_prefix = "0.0.0.0/0"
    security_group_id = openstack_networking_secgroup_v2.talos-controlplane.id
}

resource "openstack_networking_secgroup_rule_v2" "talos-trustd-controlplane" {
    direction = "ingress"
    ethertype = "IPv4"
    protocol = "tcp"
    port_range_min = 50001
    port_range_max = 50001
    remote_ip_prefix = openstack_networking_subnet_v2.talos-subnet-1.cidr
    security_group_id = openstack_networking_secgroup_v2.talos-controlplane.id
}

resource "openstack_networking_secgroup_rule_v2" "talos-apid-worker" {
    direction = "ingress"
    ethertype = "IPv4"
    protocol  = "tcp"
    port_range_min = 50000
    port_range_max = 50000
    remote_ip_prefix = openstack_networking_subnet_v2.talos-subnet-1.cidr
    security_group_id = openstack_networking_secgroup_v2.talos-workers.id
}
