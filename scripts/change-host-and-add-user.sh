#!/bin/bash

# flush stdin as usual
function flush() {
    while read -r -t 0; do
    read -r
    done
}

[ $EUID -ne 0 ] && printf "\nMust run as root\n" && exit 1

while true; do
    clear
    printf "\nWhat to do?\n1. Set hostname\n2. Add user\nOthers. Exit\n\n"
    flush
    read -p ">>> Your choice: " choice
    case "$choice" in
        1)
            flush
            read -p ">>>> New hostname: " new_host
            echo "$new_host" > /etc/hostname
            sed -i "s,$(hostname),${new_host},g" /etc/hosts
            printf "\n>>>>> Hostname changed to ${new_host}, restart your machine to apply\n"
        ;;

        2)
            flush
            read -p "Username: " new_user
            useradd -d /home/${new_user} ${new_user} -s /bin/bash
            usermod -aG sudo ${new_user}
            echo "${new_user}:toor" | chpasswd
            printf "\n>>>>> Created user ${new_user} in group sudo with password: \033[38;5;226mtoor\033[0m\n"
        ;;

        *)
        printf "\nGoodbye!\n"
        exit 0
        ;;
    esac
    sleep 3
done
