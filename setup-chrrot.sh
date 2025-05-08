#!/usr/bin/env bash
set -euo pipefail

apt update && apt install wget

PREFS_FILE="/etc/apt/preferences.d/snapshot.pref"
working_dir=$(mktemp -d)
cd $working_dir
wget https://github.com/KAINAT-OS/Kainatos-packages/raw/refs/heads/ppa/debs/kainat-os-sources-25.1.deb
dpkg -i ./*.deb

rm -fv /etc/apt/sources.list.d/thorium.list && \
wget --no-hsts -P /etc/apt/sources.list.d/ \
http://dl.thorium.rocks/debian/dists/stable/thorium.list && \
apt update

# Ensure running as root
if [[ $EUID -ne 0 ]]; then
  echo "⚠️  This script must be run as root. Aborting."
  exit 1
fi


# 1. Write the APT pinning preferences
cat > "${PREFS_FILE}" <<EOF
Package: *
Pin: origin "snapshot.debian.org"
Pin-Priority: 1001
EOF
echo "✅ Created APT preferences file at ${PREFS_FILE}"

# 3. Update APT cache
echo
echo "🔄 Updating APT cache..."
apt-get update

# 4. Perform the dist-upgrade with downgrades
echo
echo "⬇️  Downgrading all packages to snapshot versions..."
apt-get dist-upgrade --allow-downgrades -y
apt-get --fix-broken install

apt-get autoremove --purge

echo
echo "🎉 upgrade complete. Please reboot and verify system stability."
apt-get install zsh

apt-get update
apt-get  install linux-headers-amd64
apt-get install kainat-os-core
