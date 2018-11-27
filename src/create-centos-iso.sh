#!/bin/bash
set -e

MOUNT_PATH=${MOUNT_PATH:-$(mktemp -d /tmp/iso.XXXX)}
RPM_PATH=${RPM_PATH:-$PWD/RPMS}
ISO_IMAGE=${ISO_IMAGE:-$1}
ISO_OUTPUT_IMAGE=${ISO_OUTPUT_IMAGE:-$2}
BUILD_DIR=${BUILD_DIR:-$PWD/iso}
ISOLINUX_DIR=${BUILD_DIR}/isolinux
IMAGES_DIR=${ISOLINUX_DIR}/images
LIVEOS_DIR=${ISOLINUX_DIR}/LiveOS
PACKAGES_DIR=${ISOLINUX_DIR}/Packages

function error_handler(){
  local line="${1}"
  echo "Error running the ${BASH_COMMAND} at line ${line}"
  if mount | grep "$MOUNT_PATH "; then
    sudo umount $MOUNT_PATH
  fi
  if [ -d $BUILD_DIR ]; then
    rm -rf $BUILD_DIR
  fi
}

trap 'error_handler ${LINENO}' ERR
mkdir -p "${ISOLINUX_DIR}/"{images,ks,LiveOS,Packages,postinstall}
sudo mount -o loop "$ISO_IMAGE" "$MOUNT_PATH"
cp "${MOUNT_PATH}/.discinfo" "$ISOLINUX_DIR"
cp "${MOUNT_PATH}/isolinux/"* "$ISOLINUX_DIR"
rsync -av "${MOUNT_PATH}/images" "${IMAGES_DIR}"
cp "${MOUNT_PATH}/LiveOS/"* "$LIVEOS_DIR"
rsync -av "${MOUNT_PATH}/Packages/" "$PACKAGES_DIR"
if [ "$(ls RPMS)" = "" ]; then
  echo There are no custom packages to be added
else
  cp "${RPM_PATH}/"* "$PACKAGES_DIR"
fi
gunzip -c "${MOUNT_PATH}/repodata/"*minimal-x86_64-comps.xml.gz > "${BUILD_DIR}/comps.xml"
cd $ISOLINUX_DIR
createrepo -g "${BUILD_DIR}/comps.xml" .
cat <<EOF> ${ISOLINUX_DIR}/ks/ks.cfg
install
text
lang en_US.UTF-8
keyboard us
reboot --eject
firstboot --enable
auth --enableshadow --passalgo=sha512

# Network information
network  --bootproto=dhcp --device=enp0s3 --onboot=on --ipv6=auto --activate
network  --bootproto=static --device=enp0s8 --ip=10.10.10.12 --netmask=255.255.255.0 --ipv6=auto --activate
network --device=lo  --hostname=localhost.localdomain

rootpw --lock
timezone America/New_York --isUtc
user --name=stx --plaintext --password stx@123 --groups=wheel

autopart --type=lvm
# Partition clearing information
clearpart --all --initlabel --drives=sda

cdrom

%packages --nobase --ignoremissing
$(for package in $(ls $RPM_PATH/*.rpm); do rpm -qp --queryformat '%{NAME}' ${RPM_PATH}/${package}; printf "\n"; done)
@^minimal
%end

%post
echo "Succefully kickstart Tested" >> /root/README

%end
EOF

sed -ie "/.*menu default$/d" "$ISOLINUX_DIR/isolinux.cfg"
cat <<EOF>> "$ISOLINUX_DIR/isolinux.cfg"
label linux
  menu label ^Install Centos 7
	menu default
  kernel vmlinuz
  append initrd=initrd.img inst.stage2=hd:LABEL=CentOS\x207\x20x86_64 ks=cdrom:/ks/ks.cfg quiet
EOF
sudo umount $MOUNT_PATH
cd $BUILD_DIR
mkisofs -o $ISO_OUTPUT_IMAGE -b isolinux.bin -c boot.cat -no-emul-boot -V 'CentOS 7 x86_64' -boot-load-size 4 -boot-info-table -R -J -v -T isolinux/
sudo rm -rf $BUILD_DIR
