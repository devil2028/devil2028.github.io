#!/bin/bash

CONFIG_FILE="$HOME/.git_profiles"

# 初始化配置文件
init_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "personal:Devil:929248212@qq.com" > "$CONFIG_FILE"
        echo "work:劉清華:qinghua.liu6@pactera.com" >> "$CONFIG_FILE"
    fi
}

switch_to_profile() {
    local profile=$1
    local scope=$2
    local scope_flag=""
    
    [ "$scope" = "global" ] && scope_flag="--global" || scope_flag=""
    
    if grep -q "^$profile:" "$CONFIG_FILE"; then
        local name=$(grep "^$profile:" "$CONFIG_FILE" | cut -d: -f2)
        local email=$(grep "^$profile:" "$CONFIG_FILE" | cut -d: -f3)
        git config $scope_flag user.name "$name"
        git config $scope_flag user.email "$email"
        echo "已切换到 $profile 账号（${scope}）："
        echo "Name: $name"
        echo "Email: $email"
    else
        echo "找不到配置文件 $profile"
        list_profiles
    fi
}

show_current() {
    echo "当前 Git 用户配置："
    echo "本地配置："
    echo "Name: $(git config user.name)"
    echo "Email: $(git config user.email)"
    echo ""
    echo "全局配置："
    echo "Name: $(git config --global user.name)"
    echo "Email: $(git config --global user.email)"
}

list_profiles() {
    echo "可用的配置文件："
    while IFS=: read -r profile name email; do
        echo "- $profile (Name: $name, Email: $email)"
    done < "$CONFIG_FILE"
}

add_profile() {
    local profile=$1
    local name=$2
    local email=$3
    echo "$profile:$name:$email" >> "$CONFIG_FILE"
    echo "已添加新配置 $profile"
}

init_config

case "$1" in
    "personal"|"work")
        scope="local"
        [ "$2" = "global" ] && scope="global"
        switch_to_profile "$1" "$scope"
        ;;
    "show")
        show_current
        ;;
    "list")
        list_profiles
        ;;
    "add")
        if [ "$#" -eq 4 ]; then
            add_profile "$2" "$3" "$4"
        else
            echo "使用方法: ./switch_git_user.sh add <profile> <name> <email>"
        fi
        ;;
    *)
        echo "使用方法："
        echo "./switch_git_user.sh personal [global]  # 切换到个人账号"
        echo "./switch_git_user.sh work [global]      # 切换到工作账号"
        echo "./switch_git_user.sh show               # 显示当前配置"
        echo "./switch_git_user.sh list               # 显示所有可用配置"
        echo "./switch_git_user.sh add <profile> <name> <email>  # 添加新配置"
        ;;
esac 