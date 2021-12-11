#!/usr/bin/env bash
set -euxo pipefail
# set -u  # 遇到不存在的变量直接退出
# set -x  # 输出结果前打印命令
# set -eo pipefail  # 只要发生错误，脚本终止执行。管道中的命令也一样

COLOR_ERROR="\e[38;5;198m"
COLOR_NONE="\e[0m"
COLOR_SUCC="\e[92m"

# 检查某个命令是否安装
function CMDExist() {
    local cmd="$1"
    if [ -z "$cmd" ];then
        echo "Usage CMDExist YourCMD"
        return 1
    fi

    command "$cmd" >/dev/null 2>&1
    if [ $? -eq 0 ];then
        return 0
    fi

    return 2
}




function log() {
    echo $(date '+%Y-%m-%d %H:%M:%S')" INFO:  "$@
    $@
}

function main() {
    sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove

    # zsh
    log "START: install zsh" && sudo apt install -y zsh && log "END: install zsh"

    # docker
    if ! CMDExist docker;then
        echo "install docker please"
    fi
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
}

function test() {
    log "echo xixi"
    if ! CMDExist docker;then
        echo "install docker please"
    fi
}

test