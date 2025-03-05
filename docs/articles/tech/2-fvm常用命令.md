
# 常用命令

```
fvm flutter list # 查看已经安装的flutter版本
fvm flutter use <flutter_version> # 使用某个flutter版本
fvm flutter install <flutter_version> # 安装flutter版本
fvm flutter current # 查看当前使用的flutter版本
fvm remove <flutter_version> # 移除某个flutter版本
fvm upgrade # 升级fvm本身
```

# 运行Android项目

```
fvm flutter --version
fvm flutter run
fvm flutter run --debug
fvm flutter run --release
```


# 打包apk

```
fvm flutter build apk --release
fvm flutter build apk --debug
```

# 打包aab

```
fvm flutter build appbundle --release
```


