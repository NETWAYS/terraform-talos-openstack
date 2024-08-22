resource "openstack_images_image_v2" "talos-175" {
    name             = "Talos v1.7.5"
    image_source_url = "https://factory.talos.dev/image/376567988ad370138ad8b2698212367b8edcb69b5fd68c80be1f2ec7d603b4ba/v1.7.5/openstack-amd64.raw.xz"
    container_format = "bare"
    disk_format      = "raw"
    decompress       = "true"
}

resource "openstack_networking_floatingip_v2" "talos-controlplane" {
    pool    = "public-network"
    port_id = openstack_networking_port_v2.talos-controlplane.id
}

resource "openstack_networking_port_v2" "talos-controlplane" {
    depends_on         = [openstack_networking_subnet_v2.talos-subnet-1]
    name               = "talos-controlplane"
    network_id         = openstack_networking_network_v2.talos.id
    admin_state_up     = true
    security_group_ids = [openstack_networking_secgroup_v2.talos-controlplane.id]
}

resource "openstack_networking_port_v2" "talos-workers" {
    depends_on         = [openstack_networking_subnet_v2.talos-subnet-1]
    count              = 2
    name               = "talos-worker-${count.index}"
    network_id         = openstack_networking_network_v2.talos.id
    admin_state_up     = true
    security_group_ids = [openstack_networking_secgroup_v2.talos-workers.id]
}

resource "openstack_compute_instance_v2" "talos-controlplane" {
    name      = "talos-controlplane"
    image_id  = openstack_images_image_v2.talos-175.id
    flavor_id = data.openstack_compute_flavor_v2.s1-small.id
    user_data = file("controlplane.yaml")

    network {
        port = openstack_networking_port_v2.talos-controlplane.id
    }
}

resource "openstack_compute_instance_v2" "talos-workers" {
    count     = 2
    name      = "talos-worker-${count.index}"
    image_id  = openstack_images_image_v2.talos-175.id
    flavor_id = data.openstack_compute_flavor_v2.s1-small.id
    user_data = file("worker.yaml")

    network {
        port = openstack_networking_port_v2.talos-workers[count.index].id
    }
}
