#!/bin/bash

device=$(xinput list --name-only | grep -i "Touchpad")
state=$(xinput list-props "$device" | grep "Device Enabled" | awk '{print $4}')

if [ "$state" == "1" ]; then
	xinput disable "$device"
else
	xinput enable "$device"
fi

# Add gesture line to ~/.config/libinput-gestures.conf and restart libinput-gestures
# Toggle touchpad on/off with a 4-finger tap
# gesture tap 4 xdotool exec ~/toggle_touchpad.sh
