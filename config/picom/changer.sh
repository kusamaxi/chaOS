#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Usage: $0 none|clear|blur"
	exit 1
fi

CONFIG_NAME="$1"
PICOM_DIR="$HOME/.config/picom"

case $CONFIG_NAME in
none | clear | blur) ;;
*)
	echo "Invalid argument. Usage: $0 none|clear|blur"
	exit 1
	;;
esac

CONFIG_FILE="$PICOM_DIR/$CONFIG_NAME.conf"

if [ ! -f "$CONFIG_FILE" ]; then
	echo "Configuration file not found: $CONFIG_FILE"
	exit 1
fi

pkill picom

# Wait for picom to completely shut down
while pgrep -x picom >/dev/null; do
	sleep 0.1
done

picom --config "$CONFIG_FILE" -b &
