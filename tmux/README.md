## github
https://github.com/gpakosz/.tmux

## 备份
```sh
# diff
code -d ~/Desktop/dotfiles/tmux/.tmux.conf.local ~/.tmux.conf.local

# 备份
cp ~/.tmux.conf.local ~/Desktop/dotfiles/tmux/
```

## 恢复
```sh
# clone至home目录
cd ~ && git clone https://github.com/gpakosz/.tmux.git 
ln -s -f .tmux/.tmux.conf

# 回到dotfile目录将配置文件拷贝过来
cp  ~/Desktop/dotfiles/tmux/.tmux.conf.local  ~/
```