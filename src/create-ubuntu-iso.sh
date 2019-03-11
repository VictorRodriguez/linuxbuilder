#!/bin/bash
set -e

MOUNT_PATH=${MOUNT_PATH:-$(mktemp -d /tmp/iso.XXXX)}
DEB_PATH=${RPM_PATH:-$PWD/DEBS}
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
sudo mount -o loop ${ISO_IMAGE} "$MOUNT_PATH"
rsync -av ${MOUNT_PATH}/* ${BUILD_DIR}
rsync -av ${MOUNT_PATH}/.disk ${BUILD_DIR}
sudo umount ${MOUNT_PATH}

mkdir ${BUILD_DIR}/ks
sudo chmod a+w -R "$BUILD_DIR"
sed -i "s|^default.*$|default lbuilder|" "$ISOLINUX_DIR/txt.cfg"

cat<<EOF> ${BUILD_DIR}/preseed/custom.seed
#User Configuration
d-i passwd/root-login boolean false
d-i passwd/make-user boolean true
d-i passwd/user-fullname string StarlingX
d-i passwd/username string stx
d-i passwd/user-password password stx!1234
d-i passwd/user-password-again password stx!1234
d-i passwd/user-uid string
d-i user-setup/allow-password-weak boolean true
d-i passwd/user-default-groups string adm cdrom dialout lpadmin plugdev
d-i user-setup/encrypt-home boolean false
#Disk configuration
d-i partman/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm_nooverwrite boolean true
d-i partman/confirm boolean true
d-i partman-auto/purge_lvm_from_device boolean true
d-i partman-lvm/device_remove_lvm boolean true
d-i partman-lvm/confirm boolean true
d-i partman-lvm/confirm_nooverwrite boolean true
d-i partman-auto-lvm/no_boot boolean true
d-i partman-md/device_remove_md boolean true
d-i partman-md/confirm boolean true
d-i partman-md/confirm_nooverwrite boolean true
d-i partman-auto/method string lvm
d-i partman-auto-lvm/guided_size string max
d-i partman-partitioning/confirm_write_new_label boolean true
d-i grub-installer/only_debian boolean true
d-i grub-installer/with_other_os boolean true
d-i debian-installer/language string en_US:en
d-i debian-installer/country string US
d-i debian-installer/locale string en_US
d-i debian-installer/splash boolean false
d-i localechooser/supported-locales multiselect en_US.UTF-8
d-i pkgsel/install-language-support boolean true
d-i console-setup/ask_detect boolean false
d-i keyboard-configuration/modelcode string pc105
d-i keyboard-configuration/layoutcode string us
d-i keyboard-configuration/variantcode string intl
d-i keyboard-configuration/xkb-keymap select us(intl)
d-i debconf/language string en_US:en
d-i netcfg/enable boolean false
d-i netcfg/get_hostname string stx-ubuntu
d-i netcfg/get_domain string stx-ubuntu
d-i time/zone string US/Eastern
d-i clock-setup/utc boolean true
d-i clock-setup/ntp boolean false
d-i apt-setup/use_mirror boolean false
#Install Basic Ubuntu Server
tasksel tasksel/first multiselect Basic Ubuntu server
d-i pkgsel/update-policy select none
d-i pkgsel/updatedb boolean true
#Install extra debian packages
d-i preseed/late_command string in-target dpkg -i$(for deb in $(ls $DEB_PATH/*.deb | sed 's|^.*/||'); do \
  printf " /media/cdrom/pool/extras/$deb";\
  done)
#Finish installation
d-i finish-install/reboot_in_progress note
d-i finish-install/keep-consoles boolean false
d-i cdrom-detect/eject boolean true
d-i debian-installer/exit/halt boolean false
d-i debian-installer/exit/poweroff boolean false
EOF

cat <<EOF>> "$ISOLINUX_DIR/txt.cfg"
label lbuilder
  menu label ^Install Custom Ubuntu Server
  kernel /install/vmlinuz
  append file=/cdrom/preseed/ubuntu-server.seed initrd=/install/initrd.gz auto=true priority=high preseed/file=/cdrom/preseed/custom.seed --
EOF

cd $BUILD_DIR
mkdir $BUILD_DIR/pool/extras
cp -f $DEB_PATH/* $BUILD_DIR/pool/extras/.

sudo md5sum `find ! -name “md5sum.txt” ! -path “./isolinux/*” -follow -type f` > md5sum.txt
sudo chmod a-w -R "$BUILD_DIR"
sudo mkisofs -J -l -b isolinux/isolinux.bin -no-emul-boot -boot-load-size 5 -boot-info-table -z -iso-level 4 -c isolinux/isolinux.cat -o $ISO_OUTPUT_IMAGE -joliet-long $BUILD_DIR
sudo rm -rf $BUILD_DIR
