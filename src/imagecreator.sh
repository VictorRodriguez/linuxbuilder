#!/usr/bin/env bash

BASE_DIR=$(dirname $(pwd))
ISO_FILES=$2

#YUM_REPO=$3
PKG_DIR=$BASE_DIR/packages
ISO_DIR=$BASE_DIR/iso

if [ -z "$1" ]; then
	ISO_NAME=stx.iso
else
	ISO_NAME=$1
	shift
fi

echo $ISO_DIR
mkisofs -o $ISO_DIR/$ISO_NAME $PKG_DIR
