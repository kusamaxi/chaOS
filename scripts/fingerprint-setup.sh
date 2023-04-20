#!/bin/bash

# Update system and install necessary packages
pacman -Syu --noconfirm
pacman -S --noconfirm fprintd libgusb pixman nss systemd libgudev base-devel git meson

# Clone the latest libfprint repository
git clone https://gitlab.freedesktop.org/libfprint/libfprint.git
cd libfprint

# Build and install the latest libfprint
meson _build
ninja -C _build
sudo ninja -C _build install

# Enroll fingerprint
fprintd-enroll

# Create a new PAM configuration folder and copy current configuration files
mkdir -p /etc/pam.d-fingerprint
cp /etc/pam.d/* /etc/pam.d-fingerprint/

# Add fingerprint authentication to the copied PAM configuration files
for pam_file in "system-local-login" "system-login" "sudo"; do
	sed -i '/^auth.*include.*/i auth      sufficient pam_fprintd.so' /etc/pam.d-fingerprint/${pam_file}
done

echo "Fingerprint setup completed."
echo "You can switch to the new PAM configuration by running:"
echo "sudo cp /etc/pam.d-fingerprint/* /etc/pam.d/"
