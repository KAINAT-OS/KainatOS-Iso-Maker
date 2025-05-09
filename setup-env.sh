#!/bin/bash
set -e
source ./config.sh
if [ -e "./Debian.iso" ]; then
    echo "found it"
    
else
    wget -O ./Debian.iso https://cdimage.debian.org/mirror/cdimage/archive/$deb_version-live/amd64/iso-hybrid/debian-live-$deb_version-amd64-kde.iso
fi

if [ -d ./chroot]; then
    mkdir chroot
fi

cubic ./chroot ./Debian.iso
exit 0
