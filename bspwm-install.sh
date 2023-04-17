#!/bin/bash

# Easy setup for testing
mkdir ~/.local/share/fonts
cp -R fonts/* ~/.local/share/fonts/
# replace with linking and install either /usr/share/chaos or ~/.local/share/chaos
ln -s ${pwd}/config/* ~/.config/
chmod -R +x ~/.config/bspwm
chmod -R +x ~/.config/polybar/scripts
sudo pacman -Syu --needed --noconfirm - <packages-repository.txt
sudo fc-cache -f -v
