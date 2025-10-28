#!/usr/bin/env bash

source "sharedFuncs.sh"

main() {    

    CMD_PATH="/usr/local/bin/photoshop"
    ENTRY_PATH="/home/$USER/.local/share/applications/photoshop.desktop"
    
    notify-send "Photoshop CC" "photoshop uninstaller started" -i "photoshop"

    ask_question "Uninstalling photoshop CC 2018. Are you sure?" "N"
    if [ $result == "no" ];then
        echo "Uninstalling..."
        exit 0
    fi
    
    #remove photoshop directory
    if [ -d "$SCR_PATH" ];then
        echo "Removing photoshop directory..."
        rm -r "$SCR_PATH" || error2 "Couldn't remove photoshop directory"
        sleep 4
    else
        echo "photoshop directory Not Found!"
    fi
    
    
    #Unlink command 
    if [ -L "$CMD_PATH" ];then
        echo "Removing launcher command..."
        sudo unlink "$CMD_PATH" || error2 "Couldn't remove launcher command"
    else
        echo "Launcher command Not Found!"
    fi

    #delete desktop entry
    if [ -f "$ENTRY_PATH" ];then
        echo "Removing desktop entry...."
        echo "$SCR_PATH"
        rm "$ENTRY_PATH" || error2 "Couldn't remove desktop entry"
    else
        echo "Desktop entry Not Found!"
    fi

    #delete cache directoy
    if [ -d "$CACHE_PATH" ];then
        echo "--------------------------------"
        echo "Downloadeds are cached, and you can use them to reinstall photoshop without redownloading."
        echo -e "your cache directory is \033[1;36m$CACHE_PATH\e[0m"
        echo "--------------------------------"
        ask_question "Delete cache directory?" "N"
        if [ "$result" == "yes" ];then
            rm -rf "$CACHE_PATH" || error2 "Couldn't remove cache directory"
            show_message2 "Cache directory removed."
        else
            echo "You can use cached downloads later to install photoshop"
        fi
    else
        echo "Cache directory Not Found!"    
    fi

}

#parameters [Message] [default flag [Y/N]]
function ask_question() {
    result=""
    if [ "$2" == "Y" ];then
        read -r -p "$1 [Y/n] " response
        if [[ "$response" =~ $(locale noexpr) ]];then
            result="no"
        else
            result="yes"
        fi
    elif [ "$2" == "N" ];then
        read -r -p "$1 [N/y] " response
        if [[ "$response" =~ $(locale yesexpr) ]];then
            result="yes"
        else
            result="no"
        fi
    fi
}

load_paths
main
