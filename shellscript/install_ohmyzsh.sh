#!/usr/bin/env bash
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
    sh -c "$(wget -O- https://cdn.jsdelivr.net/gh/ohmyzsh/ohmyzsh@master/tools/install.sh)"

}

# 3. 自定义配置
function config() {

}

function main() {
    install_zsh
    install_ohmyzsh
    config
}

main