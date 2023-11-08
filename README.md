# Playground for [bootc](https://containers.github.io/bootc/)

This repository aims at facilitating getting used to [bootc](https://containers.github.io/bootc/) and may serve as template for future documentation or tutorials.
[bootc](https://containers.github.io/bootc/) is built upon and uses many technologies that we try to hide as much as possible such that you can focus on bootc and do not need to fight your way through setting up a VM.

## Install a Fedora CoreOS VM

* `make download` to download a [Fedora CoreOS](https://docs.fedoraproject.org/en-US/fedora-coreos/getting-started/) image.
* `make vm-install` to install a VM with `virt-install`
* `make vm-{start,stop}` to start and stop the local VM
* `make vm-remove` to remove the local VM
* `make vm-ip` to inspect the IP address of the VM (e.g., to `ssh core@IP` into it)

The default user is `core` with the password `core`.  Once you have the VM installed and running, you are ready to play with bootc.
