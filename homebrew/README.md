# homebrew-bundle

## 备份

```sh
# 执行 brew bundle dump 备份命令 
brew bundle dump --describe --force --file="~/Desktop/Brewfile"

# diff
code -d ~/Desktop/dotfiles/homebrew/Brewfile ~/Desktop/Brewfile

# 参数说明 
--describe：为列表中的命令行工具加上说明性文字。
--force：直接覆盖之前生成的 Brewfile 文件。
--file="~/Desktop/Brewfile"：在指定位置生成文件。如果没有该参数，则在当前目录生成 Brewfile 文件.

```

## 恢复

```sh
# 安装 Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# 安装 mas, 没从 app store 下载软件就别装
# brew install mas

# 批量安装软件
brew bundle --file="~/Desktop/dotfiles/homebrew/Brewfile"
# setapp这个软件安装貌似有问题，建议手动重装
```

## 常用命令说明
```sh
# 搜索软件
brew search docker
# 显示产品信息
brew info docker
# 单行显示已安装的软件包
brew cask list -1
# 显示可更新的软件包
brew cask outdated
# 更新过期的软件包
brew cask upgrade
# 软件包的安装与卸载
brew cask install setapp
brew cask uninstall setapp
brew cask reinstall setapp
```
