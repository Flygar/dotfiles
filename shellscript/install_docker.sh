#!/usr/bin/env bash
# https://github.com/Flygar/dotfiles/blob/main/shellscript/env
source <(curl -fsSL https://raw.githubusercontent.com/Flygar/dotfiles/main/shellscript/env)
set -euo pipefail

# 安装docker
# 参考官网相应操作系统的安装方式: https://docs.docker.com/engine/install/debian/
# 脚本安装: https://docs.docker.com/engine/install/debian/#install-using-the-convenience-script
function install_docker() {
    if ! [ -x "$(command -v docker)" ]; then
        echo "Install the latest stable release of Docker on Linux"
        curl -fsSL https://get.docker.com -o- | sudo sh
    else
        printf "${COLOR_SUCC}Docker CE already installed${COLOR_NONE}\n"
    fi
}

# Manage Docker as a non-root user
# 授权非root用户使用docker
# 参考: https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user
function post_install() {
    # 判断用户是否存在，用户不存在则新建用户
    local USER=$1

    # 新增docker用户组
    sudo groupadd docker >/dev/null 2>&1 || printf "${COLOR_SUCC}group 'docker' already exists${COLOR_NONE}\n"

    # 把用户添加到docker组内
    sudo usermod -aG docker $USER 
    newgrp docker

    # TODO 跟随系统启动 debian系统不用动，已经设置好了
    # 参考: https://docs.docker.com/engine/install/linux-postinstall/#configure-docker-to-start-on-boot

    # # 查看系统启动服务 
    # systemctl list-units --type=service --state=running
    # systemctl list-unit-files --type=service --state=enabled
    # systemctl list-unit-files --type=service --state=disabled
}

function main() {
    install_docker
    post_install law
}

main
