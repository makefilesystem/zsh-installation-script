#!/bin/bash

GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
RESET="\033[0m"

function print_header {
    echo -e "${YELLOW}==================================================${RESET}"
    echo -e "${GREEN}$1${RESET}"
    echo -e "${YELLOW}==================================================${RESET}"
}

function clear_terminal {
    history -c
    clear
    echo -e "${GREEN}codedbymkfs${RESET}"
}

function select_distro {
    echo -e "${GREEN}Пожалуйста, выберите ваш дистрибутив:${RESET}"
    echo "1) Ubuntu/Debian"
    echo "2) Fedora"
    echo "3) Arch/Manjaro"
    echo "4) OpenSUSE"
    echo "5) Gentoo"
    echo "6) NixOS"
    echo "7) CentOS/RHEL"
    echo "8) Alpine"
    echo "9) Выход"
    echo -n "Введите номер (1-9): "

    read -r DISTRO_CHOICE
    case "$DISTRO_CHOICE" in
        1)
            DISTRO="ubuntu"
            ;;
        2)
            DISTRO="fedora"
            ;;
        3)
            DISTRO="arch"
            ;;
        4)
            DISTRO="opensuse"
            ;;
        5)
            DISTRO="gentoo"
            ;;
        6)
            DISTRO="nixos"
            ;;
        7)
            DISTRO="centos"
            ;;
        8)
            DISTRO="alpine"
            ;;
        9)
            echo -e "${RED}Выход из скрипта.${RESET}"
            exit 0
            ;;
        *)
            echo -e "${RED}Неверный выбор. Пожалуйста, выберите корректный номер.${RESET}"
            select_distro
            ;;
    esac
}

function install_zsh {
    print_header "Установка Zsh и необходимых пакетов"

    case "$DISTRO" in
        ubuntu)
            sudo apt update
            sudo apt install -y zsh git curl
            ;;
        fedora)
            sudo dnf install -y zsh git curl 
            ;;
        arch)
            sudo pacman -Syu --noconfirm zsh git curl 
            ;;
        opensuse)
            sudo zypper refresh
            sudo zypper install -y zsh git curl
            ;;
        gentoo)
            sudo emerge -avg app-shells/zsh app-shells/zsh-completions dev-vcs/git
            ;;
        nixos)
            nix-env -iA nixpkgs.zsh nixpkgs.git
            ;;
        centos)
            sudo yum install -y epel-release
            sudo yum install -y zsh git curl
            ;;
        alpine)
            sudo apk add zsh git curl 
            ;;
        *)
            echo -e "${RED}Этот дистрибутив не поддерживается.${RESET}"
            exit 1
            ;;
    esac
}

function install_ohmyzsh {
    print_header "Установка Oh My Zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

function install_powerlevel10k {
    print_header "Установка Powerlevel10k"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
    sed -i 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' $HOME/.zshrc
}

function install_zsh_plugins {
    print_header "Установка плагинов Zsh"

    # zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    # zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-syntax-highlighting $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

    #.zshrc
    sed -i 's|^plugins=.*|plugins=(git zsh-autosuggestions zsh-syntax-highlighting)|' $HOME/.zshrc

    echo -e "${GREEN}Плагины успешно установлены и настроены.${RESET}"
}

function set_zsh_default {
    print_header "Установка Zsh по умолчанию"
    chsh -s $(which zsh)
    echo -e "${GREEN}Zsh установлен как шелл по умолчанию.${RESET}"
}

# Процессы
clear_terminal
print_header "Скрипт установки Zsh с плагинами"
select_distro
install_zsh
install_ohmyzsh
install_powerlevel10k
install_zsh_plugins
set_zsh_default

echo -e "${GREEN}Установка завершена! Перезайдите в терминал, чтобы изменения вступили в силу.${RESET}"
