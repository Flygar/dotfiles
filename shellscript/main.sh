#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/Flygar/dotfiles/main/shellscript/env)
set -euo pipefail

# 升级&安装
function install() {
    local APP_LIST=$@
    printf "\n"
    # update list of available packages & upgrade
    wait4done "sudo apt update >/dev/null 2>&1" "${COLOR_SUCC}>>>update${COLOR_NONE}"
    wait4done "sudo apt full-upgrade -y >/dev/null 2>&1" "${COLOR_SUCC}>>>full-upgrade${COLOR_NONE}"    
    wait4done "sudo apt install -y ${APP_LIST} >/dev/null 2>&1" "${COLOR_SUCC}>>>install ${APP_LIST}${COLOR_NONE}"
    wait4done "sudo apt autoremove >/dev/null 2>&1" "${COLOR_SUCC}>>>autoremove${COLOR_NONE}"
}

# 变更ssh端口
function update_ssh_port() {
    # 获取配置文件中的当前端口
    local current_port=$(cat /etc/ssh/sshd_config | grep ^Port)
    local current_port_num=${current_port#* }
    if [ $(echo ${current_port} | wc -l) -ne 1 ];then
        printf "${COLOR_ERROR}Multiple port lines${COLOR_NONE}\n"
        exit 1
    fi
    local new_port="Port $1"

    # 替换为自定义端口
    sudo sed -i "s/${current_port}/${new_port}/g" /etc/ssh/sshd_config
}

# 将/etc/ssh/sshd_config文件中符合条件的行替换为新值
function sshd_config_replace() {
    local text=${1%% *}
    local file_path='/etc/ssh/sshd_config'
    local line_conf=$(cat ${file_path} | grep ${text} | grep -E 'yes|no')
    local new_line_conf=$1

    sudo sed -i "s/${line_conf}/${new_line_conf}/g" ${file_path}
}

# 只允许用户使用密钥的方式登陆
function authentication() {
    local rsa_path='${LOCAL_RSA_PATH}'
    local ip4=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)
    local ip6=$(/sbin/ip -o -6 addr list eth0 | awk '{print $4}' | cut -d/ -f1)

    printf "\n"
    printf "${COLOR_SUCC}>>>Set No PasswordAuthentication<<<${COLOR_NONE}\n"
    printf "${COLOR_NOTICE_BACKGROUND}Attention[1]:${COLOR_NONE}\nIf your local vps don't have an SSH key, you must generate a new SSH key to use for authentication.Paste the text below to create a new SSH key:\n\tssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f ${rsa_path}\n"
    printf "${COLOR_NOTICE_BACKGROUND}Attention[2]:${COLOR_NONE}\nMake sure you have uploaded your local SSH key to the vps. You can run the following command to upload the local SSH key to the server:\n\tssh-copy-id -p ${NEW_PORT} -i ${rsa_path} ${NEW_USER}@${ip4}\n"

    while :
        do  
            read -p "If SSH key has been uploaded to the vps, Press '[Y/n]' to continue: " key
            case ${key} in
                [yY] | [yY][Ee][Ss] )     
                    wait4done "sshd_config_replace 'PasswordAuthentication no'  >/dev/null 2>&1 " "${COLOR_SUCC}>>>sshd_config_replace${COLOR_NONE}"
                    break
                    ;;
                [nN] | [nN][oO] )
                    exit 1
                    # return 0
                    ;;
                [qQ] )
                    exit 1
                    ;;
                * )
                    printf "${COLOR_ERROR}Incorrect Key! Please Try Again.${COLOR_NONE}\n"
                    # printf "Press any key to continue..."
                    # read -n 1
                    # clear
                    ;;
            esac
        done 

}

# TODO 开启防火墙
function ufw() {
    echo "y" | sudo ufw enable
    sudo ufw allow ${NEW_PORT}
    # 新建的用户名：去除首位空格
    echo "ufw enable"

}

function restart_sshd() {
    sudo systemctl reload ssh.service
    # sudo systemctl restart ssh.service
}

function init() {
    while :
        do  
            read -p "Change SSH port(22) to: " NEW_PORT
            # 判断选择的端口是否被占用
            if sudo lsof -i:${NEW_PORT} >/dev/null 2>&1 ; then
                printf "${COLOR_ERROR}Port ${NEW_PORT} is used. Select another port.${COLOR_NONE}\n"
            elif ! [ ${NEW_PORT} -gt 900 ] >/dev/null 2>&1 ; then
                printf "${COLOR_ERROR}Not a number in port range[1024-65535]${COLOR_NONE}\n"
            else
                break
            fi
        done 

    while :
        do  
            read -p "Add a New user, Name: " NEW_USER
            # 是否存在新用户
            if [ ${NEW_USER} = "root" ] ; then
                printf "${COLOR_ERROR}USER ${NEW_USER} is not allowed.${COLOR_NONE}\n"
            fi
            read -s -p "Create a password for「 ${NEW_USER} 」: " NEW_USER_PASSWD
            printf "\n"
            break
        done 

}

function check() {
    while :
        do  
            printf "\n${COLOR_SUCC}>>>Information Check<<<${COLOR_NONE}\n"
            printf "Change SSH port(22) to: ${NEW_PORT}\n" 
            printf "User name to be configured:「 ${NEW_USER} | ${NEW_USER_PASSWD} 」\n"
            read -p "${COLOR_NOTICE}Is the information correct? [Y/n]: ${COLOR_NONE}" key
            case ${key} in
                [yY] | [yY][Ee][Ss] )     
                    return 0
                    ;;
                [nN] | [nN][oO] )   
                    printf "\n"
                    init
                    ;;
                [qQ] )
                    exit 1
                    ;;
                * )
                    printf "${COLOR_ERROR}Incorrect key. Please try again${COLOR_NONE}\n"
                    # printf "Press any key to continue..."
                    # read -n 1
                    # clear
                    ;;
            esac
        done 


}

# main
function main() {
    init && check

    # TODO sudo命令在debian下没有，需要提前用root用户安装下
    # 安装自定义软件
    install "sudo vim zsh git nmap ufw curl netcat"

    # 用户配置
    wait4done "personal_config" "${COLOR_SUCC}>>>personal_config${COLOR_NONE}"

    # 更改ssh登陆端口
    wait4done "update_ssh_port "${NEW_PORT}"" "${COLOR_SUCC}>>>update_ssh_port${COLOR_NONE}" && restart_sshd && ufw
    
    # 添加新用户
    wait4done "add1user "${NEW_USER}" '${NEW_USER_PASSWD}'" "${COLOR_SUCC}>>>adduser ${NEW_USER}${COLOR_NONE}"

    # 为新用户授权免密使用sudo命令
    wait4done "visudo "${NEW_USER}"" "${COLOR_SUCC}>>>visudo${COLOR_NONE}" 

    # 禁止使用root用户登陆vps
    wait4done "sshd_config_replace 'PermitRootLogin no'" "${COLOR_SUCC}>>>sshd_config_replace${COLOR_NONE}" 

    # 禁止使用密码认证的方式登陆vps
    # 带用户指令，不能用 wait4done
    authentication && restart_sshd

    # docker

    # ohmyzsh
}

main

# apt install sudo curl && bash <(curl -fsSL https://raw.githubusercontent.com/Flygar/dotfiles/main/shellscript/main.sh)
# apt install sudo curl && bash -c "$(wget -q -O- https://raw.githubusercontent.com/Flygar/dotfiles/main/shellscript/main.sh)"
