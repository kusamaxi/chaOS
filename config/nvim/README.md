# nvim configs

my custom lazyvim configs
```bash
# lazyvim defaults
# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}

git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

# here custom
mv ~/.config/nvim/lua/ ~/.config/nvim/lua.bak
git clone git@github.com:hitchhooker/vimrc  ~/.config/nvim/lua
```
## resources
- [lazyvim docs](https://lazyvim.org)
- [neovim](https://neovim.io/)
- [copilot.lua](https://github.com/zbirenbaum/copilot.lua)
  - To login `:Copilot auth`
- [obsidian.nvim](https://github.com/epwalsh/obsidian.nvim)
