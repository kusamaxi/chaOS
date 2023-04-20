#!/bin/bash

# Check if the script is being run as root or with sudo
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root or with sudo privileges" >&2
  exit 1
fi

# Install bbswitch if it is not already installed
if ! pacman -Q bbswitch &>/dev/null; then
  sudo pacman -S --noconfirm bbswitch
fi

# Load the bbswitch kernel module
sudo modprobe bbswitch

# Check the status of bbswitch
cat /proc/acpi/bbswitch

# Enable the NVIDIA GPU
echo "ON" | sudo tee /proc/acpi/bbswitch

# Create a configuration file for bbswitch to disable the GPU on boot
echo "options bbswitch load_state=0 unload_state=0" | sudo tee /etc/modprobe.d/bbswitch.conf

# Install nvidia-xrun if it is not already installed
if ! pacman -Q nvidia-xrun &>/dev/null; then
  sudo pacman -S --noconfirm nvidia-xrun
fi

# Create the xrun executable
cat << 'EOF' | sudo tee /usr/local/bin/xrun
#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: xrun <program>"
  exit 1
fi

nvidia-xrun "$@"
EOF

# Make the xrun executable
sudo chmod +x /usr/local/bin/xrun

# Usage: xrun <program>
# Replace <program> with the desired program to run, e.g., xrun glxgears

