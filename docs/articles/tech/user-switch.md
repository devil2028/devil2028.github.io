
在日常开发中，我们经常需要在个人项目和工作项目之间切换。这意味着要频繁地更改 Git 的用户名和邮箱配置。为了简化这个过程，我创建了一个简单的 Shell 脚本工具。

## 功能特点

- 支持全局配置和仓库级配置
- 可以保存多个用户配置文件
- 快速切换不同的 Git 用户身份
- 支持查看当前配置状态

## 完整代码

```bash
#!/bin/bash

CONFIG_FILE="$HOME/.git_profiles"

# 初始化配置文件
init_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "personal:Devil:666666@qq.com" > "$CONFIG_FILE"
        echo "work:WorkName:888888@163.com" >> "$CONFIG_FILE"
    fi
}

switch_to_profile() {
    local profile=$1
    local scope=$2
    
    if grep -q "^$profile:" "$CONFIG_FILE"; then
        local name=$(grep "^$profile:" "$CONFIG_FILE" | cut -d: -f2)
        local email=$(grep "^$profile:" "$CONFIG_FILE" | cut -d: -f3)
        
        if [ "$scope" = "global" ]; then
            # 设置全局配置
            git config --global user.name "$name"
            git config --global user.email "$email"
            # 清除本地配置
            git config --unset-all user.name
            git config --unset-all user.email
        else
            # 清除全局配置
            git config --global --unset-all user.name
            git config --global --unset-all user.email
            # 设置本地配置
            git config user.name "$name"
            git config user.email "$email"
        fi
        
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
            echo "使用方法: gituser add <profile> <name> <email>"
        fi
        ;;
    *)
        echo "使用方法："
        echo "gituser personal [global]  # 切换到个人账号"
        echo "gituser work [global]      # 切换到工作账号"
        echo "gituser show               # 显示当前配置"
        echo "gituser list               # 显示所有可用配置"
        echo "gituser add <profile> <name> <email>  # 添加新配置"
        ;;
esac
```

## 使用方法

**注意：此处以macOS为例，其他系统请自行修改。**

1. 将脚本保存到 `~/bin/gituser` 并添加执行权限：
   ```bash
   cp switch_git_user.sh ~/bin/gituser
   chmod +x ~/bin/gituser
   ```

2. 确保 `~/bin` 在你的 PATH 中：
   ```bash
   echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
   source ~/.zshrc
   ```

3. 使用示例：
   ```bash
   # 切换到个人账号（全局）
   gituser personal global

   # 切换到工作账号（仅当前仓库）
   gituser work

   # 查看当前配置
   gituser show

   # 查看所有可用配置
   gituser list

   # 添加新配置
   gituser add new-profile "Your Name" "your.email@example.com"
   ```

## 工作原理

脚本通过管理 Git 的全局配置（`~/.gitconfig`）和本地配置（`.git/config`）来实现不同级别的用户身份切换：

- 全局配置影响所有仓库
- 本地配置只影响当前仓库
- 本地配置优先级高于全局配置

## 注意事项

1. 首次运行时会自动创建配置文件
2. 配置文件存储在 `~/.git_profiles`
3. 可以随时添加新的配置文件
4. 切换配置时会自动清理其他级别的配置，避免冲突

这个工具极大地简化了在不同 Git 身份之间切换的过程，特别适合需要同时管理个人项目和工作项目的开发者。 