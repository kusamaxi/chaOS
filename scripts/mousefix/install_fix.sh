#!/bin/bash

set -e

ACCEL_SCRIPT_PATH="/usr/local/bin/corsair_harpoon_accel.py"
SERVICE_PATH="/etc/systemd/system/corsair-harpoon-accel.service"

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root"
	exit 1
fi

# Copy acceleration changing script
cp corsair_harpoon_accel.py "$ACCEL_SCRIPT_PATH"
chmod +x "$ACCEL_SCRIPT_PATH"

# Create systemd service file
cat <<EOF >corsair-harpoon-accel.service
[Unit]
Description=Corsair Harpoon Acceleration Service
After=graphical.target

[Service]
Type=simple
User=$SUDO_USER
WorkingDirectory=/home/$SUDO_USER
ExecStart=/usr/bin/env python3 $ACCEL_SCRIPT_PATH -1
Restart=always
RestartSec=5

[Install]
WantedBy=graphical.target
EOF

# Move systemd service file
mv corsair-harpoon-accel.service "$SERVICE_PATH"

# Reload systemd, enable, and start the service
systemctl daemon-reload
systemctl enable corsair-harpoon-accel.service
systemctl start corsair-harpoon-accel.service

echo "Installation completed successfully."
