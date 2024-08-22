data "openstack_compute_flavor_v2" "s1-small" {
    name = "s1.small"
}

data "openstack_compute_flavor_v2" "s1-medium" {
    name = "s1.medium"
}

data "openstack_networking_network_v2" "public-network" {
    name = "public-network"
}
