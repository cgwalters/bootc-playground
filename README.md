# Playground for [bootc](https://containers.github.io/bootc/)

This repository aims at facilitating getting used to [bootc](https://containers.github.io/bootc/) and may serve as template for future documentation or tutorials.
[bootc](https://containers.github.io/bootc/) is built upon and uses many technologies that we try to hide as much as possible such that you can focus on bootc and do not need to fight your way through setting up a VM.

## Install a [Fedora CoreOS](https://docs.fedoraproject.org/en-US/fedora-coreos/getting-started/) VM

* `make download` to download a [Fedora CoreOS](https://docs.fedoraproject.org/en-US/fedora-coreos/getting-started/) image.
* `make vm-install` to install a VM with `virt-install`
* `make vm-{start,stop}` to start and stop the local VM
* `make vm-remove` to remove the local VM
* `make vm-ip` to inspect the IP address of the VM (e.g., to `ssh core@IP` into it)

The default user is `core` with the password `core`.  Once you have the VM installed and running, you are ready to play with bootc.

### Rebase Fedora CoreOS Image

Once your VM has booted, you may rebase your image as described in the [CentOS boot documentation](https://github.com/CentOS/centos-boot/blob/main/install.md#rebasing-from-fedora-coreos).
That will rebase your VM into a bootable image with [bootc](https://containers.github.io/bootc/) installed.

Alternatively, we could `rpm-ostree install bootc` and run `bootc install{-to-filesystem}` (see [bootc-install docs](https://containers.github.io/bootc/install/#executing-bootc-install)).
However, https://github.com/containers/bootc/pull/137 needs to be addressed before we're able to do that though.  Hence, the suggested rebase when starting with a vanilla CoreOS image.
The instructions will be updated here once things run smoothly.
