#-*-makefile-*-
IMAGE ?= ""
.PHONY: iso-ubuntu iso-centos

iso-centos:
	ISO_IMAGE="$(IMAGE)" \
	ISO_OUTPUT_IMAGE="${PWD}/centos.iso"  ./src/create-centos-iso.sh

iso-ubuntu:
	ISO_IMAGE="$(IMAGE)" \
	ISO_OUTPUT_IMAGE="${PWD}/ubuntu.iso" ./src/create-ubuntu-iso.sh

clean:
	rm -rf ubuntu.iso
distclean:
	rm -rf *.iso
