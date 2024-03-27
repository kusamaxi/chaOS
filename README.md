# chaOS
**Terminal centric UX for linux**
![image](https://github.com/kusamaxi/chaOS/assets/15621959/7c54b71e-fdca-44eb-bcc9-3f380a39c73b)


## Dependencies
```sh
sudo pacman -Suy alacritty bspwm dunst nitrogen nvim picom polybar rofi sxhkd zsh xclip
# alternatively use apt for debian based systems
yay rofi-greenclip # wget https://github.com/erebe/greenclip/releases/download/v4.2/greenclip
# oh-my-zsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sh -c "$(curl -fsSL https://raw.github.com/kusamaxi/chaos-zsh/master/tools/install.sh)"
# autoenv
curl -#fLo- 'https://raw.githubusercontent.com/hyperupcall/autoenv/master/scripts/install.sh' | sh
```

## Install
```sh
cp -r fonts ~/.local/share
cp -r config/* ~/.config # or alternatively use soft linking to keep the repository updated
echo 'source ~/.config/zsh/.zshrc' >> ~/.zshrc
```


## Additional software
- [namiska](https://github.com/rotkonetworks/namiska)
- [neovim setup with chaOS styles](https://github.com/hitchhooker/vimrc)
