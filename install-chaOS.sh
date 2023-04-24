#!/bin/bash

set -e

# Usage:
# This script is used to set up a BSPWM environment with various configurations.
# It installs required packages, downloads and installs fonts, sets up configurations,
# and enables syncthing.
#
# Arguments:
# - local   : Install configuration files to the user's local directories (default)
# - global  : Install configuration files to global directories, affecting all users
# - skel    : Install configuration files to /etc/skel directory, affecting new users
#
# Usage examples:
# ./bspwm-install.sh
# ./bspwm-install.sh local
# ./bspwm-install.sh global
# ./bspwm-install.sh skel

# Define paths
LOCAL_CONFIG_PATH="${HOME}/.config"
GLOBAL_CONFIG_PATH="/etc/skel/.config"
LOCAL_SHARE_PATH="${HOME}/.local/share"
GLOBAL_SHARE_PATH="/usr/local/share"

PACMAN_CONF="/etc/pacman.conf"
MIRRORLIST_PATH="/etc/pacman.d/endeavouros-mirrorlist"

# Check the installation type
INSTALL_TYPE="${1:-local}"

case "${INSTALL_TYPE}" in
global)
	CONFIG_PATH="${GLOBAL_CONFIG_PATH}"
	SHARE_PATH="${GLOBAL_SHARE_PATH}"
	;;
skel)
	CONFIG_PATH="${GLOBAL_CONFIG_PATH}"
	SHARE_PATH="${LOCAL_SHARE_PATH}"
	;;
*)
	CONFIG_PATH="${LOCAL_CONFIG_PATH}"
	SHARE_PATH="${LOCAL_SHARE_PATH}"
	;;
esac

# Check if EndeavourOS repositories already exist
if ! grep -q "\[endeavouros\]" "${PACMAN_CONF}" || ! grep -q "\[endeavouros-repo\]" "${PACMAN_CONF}"; then
	# Add EndeavourOS repositories
	sudo bash -c "cat << EOF >> ${PACMAN_CONF}
[endeavouros]
SigLevel = PackageRequired
Include = /etc/pacman.d/endeavouros-mirrorlist

[endeavouros-repo]
SigLevel = PackageRequired
Server = https://github.com/endeavouros-team/repo/raw/master/\$repo
EOF"
fi

# Check if mirrorlist file exists
if [ ! -f "${MIRRORLIST_PATH}" ]; then
	# Create mirrorlist file
	sudo bash -c "cat << EOF > ${MIRRORLIST_PATH}
## Germany
Server = https://mirror.alpix.eu/endeavouros/repo/\$repo/\$arch

## Github
Server = https://raw.githubusercontent.com/endeavouros-team/repo/master/\$repo/\$arch
EOF"
fi

# Update package database
sudo pacman -Syy

# Install required packages for running the script
REQUIRED_PACKAGES="zsh curl unzip jq python-pyaml"
sudo pacman -Syu --needed --noconfirm ${REQUIRED_PACKAGES}

# Create necessary directories
mkdir -p "${SHARE_PATH}/fonts"
mkdir -p "${CONFIG_PATH}"

# Download and install Unbounded font
FONT_ZIP="Unbounded-Polkadot.zip"
FONT_URL="https://unbounded.polkadot.network/${FONT_ZIP}"
FONT_DIR="unbounded"

# Get the name of the zip file from the URL
ZIP_NAME=$(basename "${FONT_URL}")

curl -LO "${FONT_URL}"
unzip -o "${ZIP_NAME}" -d "${FONT_DIR}"
# Find the TTF directory after extracting the archive
TTF_DIR=$(find "${FONT_DIR}" -type d -iname "TTF" -print -quit)

if [ -z "${TTF_DIR}" ]; then
	echo "Error: TTF directory not found in the extracted archive."
	exit 1
fi

cp -R "${TTF_DIR}"/* "${SHARE_PATH}/fonts/"

# Copy other fonts
cp -R fonts/* "${SHARE_PATH}/fonts/"

# Generate packages.txt using netinstall_to_packages_parser.py
./netinstall_to_packages_parser.py

# Install packages from packages.txt
sudo pacman -Syu --needed --noconfirm - <packages.txt

# Refresh font cache
sudo fc-cache -f -v

# Symlink config files
CHAOS_CONFIG_DIR="$(pwd)/config"

for config in ${CHAOS_CONFIG_DIR}/*; do
	config_name=$(basename "${config}")
	symlink_path="${CONFIG_PATH}/${config_name}"
	if [ ! -L "${symlink_path}" ]; then
		if [ -e "${symlink_path}" ]; then
			echo "Backing up existing ${config_name} to ${config_name}.bak"
			mv "${symlink_path}" "${symlink_path}.bak"
		fi
		echo "Creating symlink for ${config_name}"
		ln -s "${config}" "${symlink_path}"
	fi
done

# Set execute permissions
chmod -R +x "${CONFIG_PATH}/bspwm"
chmod -R +x "${CONFIG_PATH}/polybar/scripts"

# Install oh-my-zsh
if [ ! -d "${HOME}/.oh-my-zsh" ]; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Run neovim setup
if [ -d "${CONFIG_PATH}/nvim.bak" ]; then
	rm -rf "${CONFIG_PATH}/nvim.bak"
fi
bash "${CHAOS_CONFIG_DIR}/nvim/setup.sh"

# Enable syncthing
sudo systemctl enable --now syncthing@$USER
