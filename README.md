# Dotfiles
To install:
```sh
# clone the repo
git clone git@github.com:exergonic/dotfiles ~/.dotfiles

# link some dotfiles to their canonical locations
ln -s ~/.dotfiles/zsh/zshrc ~/.zshrc
ln -s ~/.dotfiles/nvim ~/.config/nvim
ln -s ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/tmux ~/.tmux

# zshrc looks for a local zshrc.${HOST}
touch ~/.zshrc.${HOST}

# zshrc requires a $config_dir that points to the dotfiles
echo 'export config_dir=~/.dotfiles' >> ~/.zshrc.${HOST}
```


