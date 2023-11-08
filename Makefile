STREAM ?= stable
IMAGES_DIR:=./images

# Download the latest stable Fedora CoreOS image.
#
# Source: https://docs.fedoraproject.org/en-US/fedora-coreos/getting-started/
.PHONY: download
download:
	mkdir --parents ${IMAGES_DIR}
	coreos-installer download -s "${STREAM}" \
		--platform qemu \
		--format qcow2.xz \
		--decompress \
		--directory=${IMAGES_DIR}

# virt-install requires most paths to be absolute, so try defaulting to
# absolute as much as possible.
IGNITION_CONFIG ?= $(realpath ignition.ign)
BUTANE_CONFIG ?= $(realpath butane.bu)

# Build the ignition file that we need later on to boot and setup Fedora
# CoreOs.  For building the ignition file, we're making use of another
# configuration called Butane which is more human friendly.  The Butane file is
# then compiled into an ignition.
#
# Source: https://docs.fedoraproject.org/en-US/fedora-coreos/producing-ign/
.PHONY: ignition
ignition:
	podman run --interactive --rm quay.io/coreos/butane:release \
		--pretty --strict < ${BUTANE_CONFIG} > ${IGNITION_CONFIG}
	chcon --verbose --type svirt_home_t ${IGNITION_CONFIG}

VM_NAME ?= bootc-playground
VCPUS ?= 2
RAM_MB ?= 4096
DISK_GB ?= 10
IMAGE ?= ${IMAGES_DIR}/$(shell ls -1c ${IMAGES_DIR}|head -n1)

# Source: https://docs.fedoraproject.org/en-US/fedora-coreos/getting-started/#_booting_on_a_local_hypervisor_libvirt_example
.PHONY: vm-install
vm-install:
	@echo "Installing a new VM (${VM_NAME}) with image ${IMAGE}."
	@echo ""

	sudo virt-install \
		--connect="qemu:///system" \
		--name="${VM_NAME}" \
		--vcpus="${VCPUS}" \
		--memory="${RAM_MB}" \
		--os-variant="fedora-coreos-${STREAM}" \
		--import \
		--graphics=none \
		--disk="size=${DISK_GB},backing_store=$(realpath ${IMAGE})" \
		--network bridge=virbr0 \
		--qemu-commandline="-fw_cfg name=opt/com.coreos/config,file=${IGNITION_CONFIG}"

# Some convenience targets to manage the VM.
#
# Source: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/virtualization_deployment_and_administration_guide/part-administration
.PHONY: vm-start
vm-start:
	@echo "Starting VM ${VM_NAME}.  Run 'make vm-ip' in case you forgot the IP."
	@echo ""

	sudo virsh start ${VM_NAME}

.PHONE: vm-ip
vm-ip:
	sudo virsh net-dhcp-leases default

.PHONY: vm-stop
vm-stop:
	@echo "Shutting down VM ${VM_NAME}."
	@echo ""

	sudo virsh shutdown --domain ${VM_NAME}

.PHONY: vm-remove
vm-remove:
	@echo "Removing VM ${VM_NAME} and all its storage.  You may neeed to run 'make vm-stop' before."
	@echo ""

	sudo virsh undefine ${VM_NAME} --remove-all-storage
