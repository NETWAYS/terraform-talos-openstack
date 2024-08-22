# Talos Linux on OpenStack: Step by Step

This repository contains Terraform resources for bringing up a cluster of [Talos](https://talos.dev)
VMs on [OpenStack](https://openstack.org) using [Terraform](https://terraform.io) or
[OpenTofu](https://opentofu.org).

A step-by-step guide can be found on our blog:

- 🇬🇧 **English**: [Talos Linux on OpenStack: Step by Step](https://nws.netways.de/blog/2024/08/22/talos-linux-on-openstack-step-by-step/)
- 🇩🇪 **German**: [Talos Linux auf OpenStack: Schritt für Schritt](https://nws.netways.de/de/blog/2024/08/22/talos-linux-auf-openstack-schritt-fuer-schritt/)

## Quick Start

While we strongly encourage reading the whole step by step guide linked above, here's a primer on
how to get started with this repository.

1. Clone the repository and initialize Terraform.
   ```sh
   git clone https://github.com/NETWAYS/terraform-talos-openstack
   cd terraform-talos-openstack
   terraform init
   ```
2. Configure the OpenStack provider in `main.tf`. For configuration options, see the
   [official provider documentation](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs).
3. Let Terraform provision the resources.
   ```sh
   terraform apply
   ```
4. Generate the Talos configuration(s). Use the Floating IP from the previous step's output.
   ```sh
   talosctl gen secrets
   talosctl gen config talos-on-openstack https://<floating-ip>:6443 --with-secrets secrets.yaml
   ```
5. Let Terraform provision the resources again to apply Talos' configuration(s).
   ```sh
   terraform apply
   ```
6. Bootstrap Kubernetes using `talosctl`.
   ```sh
   talosctl bootstrap -e <floating-ip> -n <floating-ip>
   ```

## Questions and Support

Feel free to [open an issue](https://github.com/NETWAYS/terraform-talos-openstack/issues) using one of the issue templates available.

## License

The material published in this repository is licensed under the **Creative Commons Zero** license.
A copy can be found in the [`LICENSE`](./LICENSE) file in this repository.
