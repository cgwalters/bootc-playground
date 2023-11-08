# Playground for [bootc](https://containers.github.io/bootc/)

This repository aims at facilitating playing with [bootc](https://containers.github.io/bootc/).
[bootc](https://containers.github.io/bootc/) is built upon and uses many technologies that we try to hide as much as possible such that you can focus on bootc and do not need to fight your way through the Fedora CoreOS or ignition documentation.

Eventually, the playground here may aid in developing on bootc as well.

## Install a [Fedora CoreOS](https://docs.fedoraproject.org/en-US/fedora-coreos/getting-started/) VM

* `make download` to download a [Fedora CoreOS](https://docs.fedoraproject.org/en-US/fedora-coreos/getting-started/) image.
* `make vm-install` to install a VM with `virt-install`
* `make vm-{start,stop}` to start and stop the local VM
* `make vm-remove` to remove the local VM
* `make vm-ip` to inspect the IP address of the VM (e.g., to `ssh core@IP` into it)

The default user is `core` with the password `core`.  Once you have the VM installed and running, you are ready to play with bootc.

If you desire changing the ignition config (i.e., `ignition.ign`), please update the [Butane config](https://coreos.github.io/butane/specs/) (i.e., `butane.bu`) first and then run `make ignition`.
You can then git-commit the changes.

### Rebase Fedora CoreOS Image

Once your VM has booted, you may rebase your image as described in the [CentOS boot documentation](https://github.com/CentOS/centos-boot/blob/main/install.md#rebasing-from-fedora-coreos).
That will rebase your VM into a bootable image with [bootc](https://containers.github.io/bootc/) installed.

Alternatively, we could `rpm-ostree install bootc` and run `bootc install{-to-filesystem}` (see [bootc-install docs](https://containers.github.io/bootc/install/#executing-bootc-install)).
However, https://github.com/containers/bootc/pull/137 needs to be addressed before we're able to do that though.  Hence, the suggested rebase when starting with a vanilla CoreOS image.
The instructions will be updated here once things run smoothly.

Note that `bootc-install-alongside` already works on non os-tree hosts.

## Bootable Disk Images

It would be great to directly create a VM with a "bootable" disk image instead of doing the dance of first installing Fedora CoreOS and immediately rebasing or overriding it afterwards.
There are some images floating around but a more streamlined effort is currently taking place in the [CentOS boot project](https://github.com/CentOS/centos-boot/blob/main/docs/install.md#todo-use-osbuild).
Once images from the pipeline are available, the documentation here and the Makefile will be updated.
