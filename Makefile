#-*-makefile-*-
SO_IMAGE ?= ubuntu-16.04.6-server-amd64.iso
.PHONY: iso-ubuntu iso-centos

iso-centos:
	ISO_IMAGE="CentOS-7-x86_64-Minimal-1804.iso" \
	ISO_OUTPUT_IMAGE="${PWD}/centos.iso"  ./src/create-centos-iso.sh

iso-ubuntu:
	ISO_IMAGE="ubuntu-16.04.6-server-amd64.iso" \
	ISO_OUTPUT_IMAGE="${PWD}/ubuntu.iso" ./src/create-ubuntu-iso.sh
