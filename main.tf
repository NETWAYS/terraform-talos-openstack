terraform {
    required_providers {
        openstack = {
            source  = "terraform-provider-openstack/openstack"
            version = "~> 2.1.0"
        }
    }
}

provider "openstack" {
    auth_url    = "<auth_url>"
    tenant_name = "<tenant_name>"
    user_name   = "<user_name>"
    password    = "<password>"
    region      = "<region>"  # might be omitted
}
