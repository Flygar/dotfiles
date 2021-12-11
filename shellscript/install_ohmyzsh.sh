#!/usr/bin/env bash
# https://github.com/Flygar/dotfiles/blob/main/shellscript/env
source <(curl -fsSL https://cdn.jsdelivr.net/gh/Flygar/dotfiles@main/shellscript/env)
set -euxo pipefail


# 1. 判断是否安装了zsh
function install_zsh() {
    if ! [ -x "$(command -v zsh)" ]; then
        echo "Install the latest stable release of zsh on Linux"
        sudo apt update && sudo apt install wget zsh
    else
        echo -e "${COLOR_SUCC}zsh already installed${COLOR_NONE}"
    fi
}

# 2. 安装ohmyzsh
function install_ohmyzsh() {
    # https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
    sh -c "$(wget -q -O- https://cdn.jsdelivr.net/gh/ohmyzsh/ohmyzsh@master/tools/install.sh)"

}



# 3. 自定义配置
function config() {
    # 插件：zsh-autosuggestions
    # GitHub：https://github.com/zsh-users/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    # 插件：zsh-syntax-highlighting
    # GitHub；https://github.com/zsh-users/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    # 插件：git-open
    # Github：https://github.com/paulirish/git-open
    git clone https://github.com/paulirish/git-open.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/git-open

    local configPath="$HOME/.zshrc"
    # 替换THEME
    local old_theme=$(cat ${configPath} | grep '^ZSH_THEME')
    local new_theme='ZSH_THEME="steeef"'
    sudo sed -i "s/"${old_theme}"/"${new_theme}"/g" ${configPath}

    # 替换HIST_STAMPS
    local old_HIST_STAMPS=$(cat ${configPath} | grep 'HIST_STAMPS')
    local new_HIST_STAMPS='HIST_STAMPS="yyyy-mm-dd"'
    sudo sed -i "s|"${old_HIST_STAMPS}"|"${new_HIST_STAMPS}"|g" ${configPath}

    # 替换plugins
    local old_plugins=$(cat ${configPath} | grep 'plugins=(g')
    local new_plugins='plugins=(git git-open z history zsh-syntax-highlighting zsh-autosuggestions)'
    sudo sed -i "s/${old_plugins}/${new_plugins}/g" ${configPath}

    # 替换plugins
    local old_lang_env=$(cat ${configPath} | grep 'en_US.UTF-8')
    local new_lang_env='export LC_ALL=en_US.UTF-8'
    sudo sed -i "s/${old_lang_env}/${new_lang_env}/g" ${configPath}

    # 追加自定义内容
    echo "export TERM="xterm-256color"" >> ${configPath}
}

function main() {
    install_zsh
    install_ohmyzsh
    config
}

main