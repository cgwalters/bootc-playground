# Playground for [bootc](https://containers.github.io/bootc/)

The playground attempts to facilitate booting into a [bootc](https://containers.github.io/bootc/)-enabled VM.
You may boot into a Fedora Core OS VM or a Fedora Cloud image.
The Makefile tries to hide the details of downloading, running and provisioning the VMs which can consume a considerable amount of time.

## Prerequisites

The workflow is based on a Makefile and works on Linux only.
You need the following package prior to using the Makefile:

```
sudo dnf install git make coreos-installer qemu virt-install
```

You may need to `chmod o+x $HOME` in order for `make vm-install` to succeed.


## Install a [Fedora CoreOS](https://docs.fedoraproject.org/en-US/fedora-coreos/getting-started/) VM

You may also start off an ostree-enabled system, such as Fedora CoreOS.  Once installed, you can rebase the system to a bootable container and go from there.  To do that, follow the instructions below:

* `make download-fedora-coreos` to download a [Fedora CoreOS](https://docs.fedoraproject.org/en-US/fedora-coreos/getting-started/) image.
* `make vm-install-ignition` to install a VM with `virt-install`.  You may use the `IMAGE=/path/to/custom.qcow2` env variable to boot another local image.  If you face network issues, you may run `make network-setup` and set `VM_NETWORK=virbrplayground` env variable.
* `make vm-{start,stop}` to start and stop the local VM.
* `make vm-remove` to remove the local VM.
* `make vm-ip` to inspect the IP address of the VM (e.g., to `ssh core@IP` into it).

The default user is `core` with the password `core`.  Once you have the VM installed and running, you are ready to play with bootc.

If you desire changing the ignition config (i.e., `ignition.ign`), please update the [Butane config](https://coreos.github.io/butane/specs/) (i.e., `butane.bu`) first and then run `make ignition`.
You can then git-commit the changes.


### Rebase Fedora CoreOS Image

Once your VM has booted, you may rebase your image as described in the [CentOS boot documentation](https://github.com/CentOS/centos-boot/blob/main/docs/install.md).
That will rebase your VM into a bootable image with [bootc](https://containers.github.io/bootc/) installed.

Alternatively, we could `rpm-ostree install bootc` and run `bootc install{-to-filesystem}` (see [bootc-install docs](https://containers.github.io/bootc/install/#executing-bootc-install)).
However, https://github.com/containers/bootc/pull/137 needs to be addressed before we're able to do that though.  Hence, the suggested rebase when starting with a vanilla CoreOS image.
The instructions will be updated here once things run smoothly.

Note that `bootc-install-alongside` already works on non os-tree hosts.


## Mount Host Directories

If you want to mount a host directory into the VM, set the `VM_MOUNT` environment variable and run `make vm-install-*`.
The variable will instruct `virt-install` to setup a [virtiofs mount](https://libvirt.org/kbase/virtiofs.html) with the `playground-mount` tag.
The specified `VM_MOUNT` is automatically mounted at `/var/playground`.
You may mount it to a custom path via `$ sudo mount -t virtiofs playground-mount /custom/path`.

If you want to try out a development version of bootc or test a pull request, you may point `VM_MOUNT` to your local [bootc](https://github.com/containers/bootc) Git tree.
The local Git tree can then be mounted into the VM and the host's `bootc` can be executed directly.


## Bootable Disk Images

It would be great to directly create a VM with a "bootable" disk image instead of doing the dance of first installing Fedora CoreOS and immediately rebasing or overriding it afterwards.
There are some images floating around but a more streamlined effort is currently taking place in the [CentOS boot project](https://github.com/CentOS/centos-boot/blob/main/docs/install.md#todo-use-osbuild).
Once images from the pipeline are available, the documentation here and the Makefile will be updated.
