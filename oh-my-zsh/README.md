## oh-my-zsh
github地址：https://github.com/ohmyzsh/ohmyzsh

## install
```sh
# Basic Installation
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## .zshrc
```sh
cd dotfiles

# diff
code -d ~/Desktop/dotfiles/oh-my-zsh/.zshrc ~/.zshrc

# 备份
cp ~/.zshrc oh-my-zsh/.zshrc

# 还原
cp ~/Desktop/dotfiles/oh-my-zsh/.zshrc ~/.zshrc

# 插件：zsh-autosuggestions
# GitHub：https://github.com/zsh-users/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# 插件：zsh-syntax-highlighting
# GitHub；https://github.com/zsh-users/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# 插件：git-open
# Github：https://github.com/paulirish/git-open
git clone https://github.com/paulirish/git-open.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/git-open
```

## zsh-theme
```sh
cd dotfiles

# diff
code -d ~/Desktop/dotfiles/oh-my-zsh/steeef.zsh-theme ~/.oh-my-zsh/themes/steeef.zsh-theme

# 备份
cp ~/.oh-my-zsh/themes/steeef.zsh-theme oh-my-zsh/steeef.zsh-theme

# 还原
cp ~/Desktop/dotfiles/oh-my-zsh/steeef.zsh-theme ~/.oh-my-zsh/themes/steeef.zsh-theme
```