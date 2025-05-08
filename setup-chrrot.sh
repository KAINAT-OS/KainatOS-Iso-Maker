#!/usr/bin/env bash
set -euo pipefail


PREFS_FILE="/etc/apt/preferences.d/snapshot.pref"

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


echo
echo "🎉 Downgrade complete. Please reboot and verify system stability."
