#!/usr/bin/env bash
source <(curl -fsSL https://cdn.jsdelivr.net/gh/Flygar/dotfiles@master/shellscript/env)
set -euxo pipefail

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
    if [ $(echo ${current_port} | wc -l) -ne 1 ] || [ "${current_port_num}" != "22" ];then
        echo -e "${COLOR_ERROR}Multiple ports or not port 22${COLOR_NONE}"
        return 2
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
    local PORT=998
    local RSA_PATH=~/.ssh/rsa
    local USERNAME=law
    local IP_address=111

    # clear

    while :
        do  
            printf "Set no PasswordAuthentication\n\n"

            printf "If you don't already have an SSH key, you must generate a new SSH key to use for authentication.Paste the text below to create a new SSH key:\n\tssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f ~/.ssh/ww_rsa\n"

            printf "${COLOR_NOTICE_BACKGROUND}Attention:${COLOR_NONE}\nMake sure you have uploaded your local SSH key to the server. You can run the following command to upload the local SSH key to the server:\n\tssh-copy-id -p ${PORT} -i ${RSA_PATH} ${USERNAME}@${IP_address}\n"

            read -p "If SSH key has been uploaded to the vps, Press '(y/n)' to continue: " key
            case ${key} in
                [yY] | [yY][Ee][Ss] )     
                    echo "hello world"
                    ;;
                [nN] | [nN][oO] )     
                    # break
                    return 0
                    ;;
                [qQ] )
                    exit 1
                    ;;
                * )
                    printf "${COLOR_ERROR}Incorrect key, please try again${COLOR_NONE}\n"
                    # printf "Press any key to continue..."
                    # read -n 1
                    # clear
                    ;;
            esac
        done 

}

function ufw() {
    # 变更的端口
    # 新建的用户名：去除首位空格
    echo "xixi"

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
            else
                break
            fi
        done 

}

function check() {
    while :
        do  
            printf "\nInformation:\n"
            printf "Change SSH port(22) to: ${NEW_PORT}\n" 
            printf "User name to be configured: ${NEW_USER}\n"  
            read -p "${COLOR_NOTICE}Press '(y/n)' to confirm: ${COLOR_NONE}" key
            case ${key} in
                [yY] | [yY][Ee][Ss] )     
                    return 0
                    ;;
                [nN] | [nN][oO] )   
                    echo ">>>"  
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

function main() {
    #TODO debian系统下默认没sudo命令，需要提前安装下
    install "vim sudo zsh git nmap ufw curl netcat"

    # 个人配置
    actions

    # 修改ssh登陆端口为998
    update_ssh_port "998"

    # 添加新用户
    add1user "law" "foobar"
    # 设置用户执行sudo命令免密
    visudo "law"

    # 禁止使用root用户登陆服务器
    sshd_config_replace 'PermitRootLogin no'

    # 禁止通过输入密码的方式登陆服务器。
    authentication
    sshd_config_replace 'PasswordAuthentication no'



    # 重启ssh服务加载新配置
    restart_sshd
}

# test
function test() {
    init && check
    install "vim sudo zsh git nmap ufw curl netcat"
}

test

# bash <(curl -fsSL https://cdn.jsdelivr.net/gh/Flygar/dotfiles@master/shellscript/main.sh)
# bash -c "$(wget -O- https://cdn.jsdelivr.net/gh/Flygar/dotfiles@master/shellscript/main.sh)"