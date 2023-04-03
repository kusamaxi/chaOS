!/bin/bash

# Update system and install required packages
echo "Updating system and installing required packages..."
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm libwebp imagemagick

# Create the thumbnailer file
echo "Creating the thumbnailer file..."
cat << EOF | sudo tee /usr/share/thumbnailers/webp.thumbnailer
[Thumbnailer Entry]
Exec=convert %i -resize %wx%h %o
MimeType=image/webp;
EOF

# Clear the thumbnail cache
echo "Clearing the thumbnail cache..."
rm -rf ~/.cache/thumbnails/*

# Restart Thunar
echo "Done! Please restart Thunar or log out and log back in to see WebP thumbnails."
