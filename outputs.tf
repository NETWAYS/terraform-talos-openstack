output "control-plane-ip" {
    value = openstack_networking_floatingip_v2.talos-controlplane.address
}

output "worker-ip" {
    value = openstack_compute_instance_v2.talos-workers[*].access_ip_v4
}
