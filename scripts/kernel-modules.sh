#!/bin/bash

# Ensure the script is run with root privileges
if [ "$(id -u)" -ne 0 ]; then
	echo "This script must be run as root" >&2
	exit 1
fi

# Install yay if it's not already installed
if ! command -v yay &>/dev/null; then
	echo "Installing yay..."
	sudo pacman -S --needed git base-devel
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si
	cd ..
	rm -rf yay
fi

# Update the system and install the required packages
echo "Installing kernel modules..."
yay -S bbswitch acpi_call-dkms v4l2loopback-dkms

# Enable the kernel modules
echo "Enabling kernel modules..."
cat >/etc/modules-load.d/modules.conf <<EOL
bbswitch
acpi_call
v4l2loopback
EOL

echo "Installation and enabling of kernel modules complete. Please reboot your system."
