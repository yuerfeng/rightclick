# RightClick

[English](README_EN.md)

macOS Finder 右键菜单增强工具，通过 Finder Sync Extension 为访达添加实用的右键菜单功能。

## 功能

- **复制路径** - 快速复制选中文件/文件夹的完整路径到剪贴板，支持多选
- **在终端中打开** - 在 Terminal 中打开当前目录或选中文件夹所在目录
- **新建文件** - 在当前目录快速创建常用类型的文件：
  - 文本文件 (.txt)
  - Markdown (.md)
  - JSON (.json)
  - Python (.py)
  - Shell (.sh)

## 安装

### 从 DMG 安装

1. 下载最新的 `RightClick.dmg`
2. 双击打开 DMG 文件
3. 将 `rightClick.app` 拖入 `Applications` 文件夹
4. 打开应用

### 从源码构建

需要 [XcodeGen](https://github.com/yonaskolb/XcodeGen) 和 Xcode。

```bash
git clone git@github.com:yuerfeng/rightclick.git
cd rightclick
xcodegen generate
open rightClick.xcodeproj
```

在 Xcode 中选择 `rightClick` scheme，构建并运行。

## 启用扩展

首次安装后需要手动启用 Finder 扩展：

1. 打开 **系统设置** > **隐私与安全性** > **扩展** > **已添加的扩展**
2. 找到 **rightClick** 并勾选 **FinderSyncExtension**
3. 重新启动访达（可在托盘图标中操作，或按住 Option 键右键点击 Dock 上的访达图标选择「重新开启」）

## 使用

启用扩展后，在访达中右键点击文件、文件夹或空白处即可看到新增的菜单项。

应用会在菜单栏显示一个托盘图标，提供以下选项：

- **显示窗口** - 打开主界面
- **扩展设置...** - 快速跳转到系统扩展设置
- **退出 RightClick** - 退出应用

## 系统要求

- macOS 12.0 (Monterey) 或更高版本

## 技术栈

- Swift / SwiftUI
- Finder Sync Extension (FIFinderSync)
- XcodeGen 项目管理

## 许可证

MIT License
