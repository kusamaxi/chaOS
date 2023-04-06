#!/bin/bash
REPO_DIR="/usr/share/chaos/src"
CONFIG_DIR="$HOME/.config"
PICOM_CONF="$CONFIG_DIR/picom.conf"
CLEAR_CONF="$REPO_DIR/config/picom/clear.conf"
BLUR_CONF="$REPO_DIR/config/picom/blur.conf"

selected=$(echo -e "None\nClear\nBlur" | rofi -dmenu -p "Select Picom Style")

case $selected in
"None")
	[[ -L $PICOM_CONF ]] && rm $PICOM_CONF
	;;
"Clear")
	ln -sf $CLEAR_CONF $PICOM_CONF
	;;
"Blur")
	ln -sf $BLUR_CONF $PICOM_CONF
	;;
*)
	exit 1
	;;
esac

pkill picom
picom -b &
