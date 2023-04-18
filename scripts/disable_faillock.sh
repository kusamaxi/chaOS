#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
	echo "This script must be run as root"
	exit 1
fi

# Backup the original files
cp /etc/pam.d/system-auth /etc/pam.d/system-auth.backup
cp /etc/pam.d/password-auth /etc/pam.d/password-auth.backup

# Remove faillock lines from system-auth and password-auth
sed -i '/pam_faillock.so/d' /etc/pam.d/system-auth
sed -i '/pam_faillock.so/d' /etc/pam.d/password-auth

echo "Faillock has been disabled."
