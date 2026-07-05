# LocalSend Chat

基于 [LocalSend](https://github.com/localsend/localsend) 的局域网聊天增强版，在原项目文件传输功能基础上新增了完整的聊天功能。

[English](README_EN.md)

> 原项目：[https://github.com/localsend/localsend](https://github.com/localsend/localsend) | 官网：[https://localsend.org](https://localsend.org) | 协议：[Apache License 2.0](LICENSE)

## 界面

### Windows 桌面端

<img src="img/1.png" alt="Chat list" width="400"/> <img src="img/2.png" alt="Chat conversation" width="400"/>

### Android 手机端

<img src="img/3.jpg" alt="Chat list" width="200"/> <img src="img/4.jpg" alt="Chat conversation" width="200"/>

## 新增功能

### 聊天

- **1对1聊天**：与局域网内任意设备发送文字消息
- **群组聊天**：创建群组，邀请成员，群内消息实时同步
- **文件分享**：聊天中发送文件
- **聊天历史**：消息持久化存储，支持左滑删除

### 剪贴板共享

- 设置中开启 Chat / Clipboard 后，一台设备复制，所有已连接设备(同时需要开启)粘贴板同步

## 下载

| 平台    | 链接                                                            |
| ------- | --------------------------------------------------------------- |
| Android | [Releases](https://github.com/EndymionLee/localsend-chat/releases) |
| Windows | [Releases](https://github.com/EndymionLee/localsend-chat/releases) |

## 构建

```bash
cd app
flutter pub get

# Windows
flutter build windows

# Android（需要 4GB+ 可用内存）
$env:RUST_MIN_STACK = 16777216
flutter build apk --debug
```

## 协议

基于 [LocalSend](https://github.com/localsend/localsend) 修改（原作者：Tien Do Nam），Apache License 2.0。详见 [NOTICE](NOTICE)。
