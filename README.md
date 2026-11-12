<div align="center">
   <img width="217" height="217" src="./screenshots/livecontainer_icon.png" alt="Logo">
</div>

<div align="center">
  <h1><b>LiveContainer + SideStore (zh-CN)</b></h1>
  <p><i>基于 LiveContainer 与 SideStore 的简体中文版，支持应用内中英文切换（重启后生效）</i></p>

  [![Xcode - Build](https://github.com/KSLengYu/LiveContainer-SideStore-zh_CN/actions/workflows/build.yml/badge.svg?branch=main)](https://github.com/KSLengYu/LiveContainer-SideStore-zh_CN/actions/workflows/build.yml)
  [![Nightly Release](https://img.shields.io/github/v/release/KSLengYu/LiveContainer-SideStore-zh_CN?include_prereleases&label=Releases)](https://github.com/KSLengYu/LiveContainer-SideStore-zh_CN/releases/tag/nightly)
  [![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://github.com/LiveContainer/LiveContainer/blob/main/LICENSE)
</div>

<p align="center">
  <b>简体中文</b> | <a href="./README_en.md">English</a>
</p>

> [!NOTE]
> **分支说明**：  
> 本仓库是基于上游 [LiveContainer/LiveContainer](https://github.com/LiveContainer/LiveContainer) 的简体中文分支仓库；合体版内置的中文版 SideStore 来自 [KSLengYu/SideStore-zh_CN (`LiveContainerSupport` 分支)](https://github.com/KSLengYu/SideStore-zh_CN)。

## 本分支修改内容

- **LiveContainer 应用内语言切换（重启后生效）**：在 LiveContainer 设置页新增语言选择器（支持 `简体中文` / `English`），切换时不直接改写当前运行界面，而是自动弹出重启确认框并在页面内保留「需要重启应用（点击立即重启）」按钮，确认后自动重启并应用新语言。
- **SideStore 完整汉化与语言切换**：完整合入 SideStore 简体中文翻译并将字库打包至合体版 `LiveContainer.app` 中；SideStore「设置 → 个性化外观 → 语言」支持在 `简体中文` 与 `English` 间切换，同样在重启后生效并支持自动重开。
- **Apple ID 登录与异常恢复优化**：默认关闭存在兼容问题的设备端独立 Anisette，并在连续登录失败或遇到 `-80045` 异常时提供恢复弹窗（关闭设备端独立 Anisette 并重置 `adi.pb`）。
- **自动化打包与 GitHub Actions**：提供 [`scripts/build_local.sh`](./scripts/build_local.sh) 与 [`scripts/package_combined.sh`](./scripts/package_combined.sh)（搭配 [`scripts/merge_strings.py`](./scripts/merge_strings.py)），云端工作流自动编译输出 **`LiveContainer+SideStore.ipa`** 与独立版 **`SideStore-zh_CN.ipa`**（不生成单独版 LiveContainer IPA）并发布至 Releases。

## 下载安装包

| 版本 | 说明 | 下载 |
| :---: | :--- | :---: |
| **LiveContainer+SideStore.ipa** | 内置简体中文 SideStore 的合体版 | [前往 Releases](https://github.com/KSLengYu/LiveContainer-SideStore-zh_CN/releases/tag/nightly) / [直接下载](https://github.com/KSLengYu/LiveContainer-SideStore-zh_CN/releases/download/nightly/LiveContainer%2BSideStore.ipa) |
| **SideStore-zh_CN.ipa** | 独立版简体中文 SideStore | [前往 Releases](https://github.com/KSLengYu/LiveContainer-SideStore-zh_CN/releases/tag/nightly) / [直接下载](https://github.com/KSLengYu/LiveContainer-SideStore-zh_CN/releases/download/nightly/SideStore-zh_CN.ipa) |

---

## LiveContainer 简介

- **无需真正安装即可运行 iOS 应用**：LiveContainer 是一个运行在 iOS 上的应用容器（并非模拟器或虚拟机）。
- **突破免费签名数量限制**：仅占用 1 个 App 与 App ID 名额即可在容器内部安装并管理任意数量的应用，并支持同一应用多开与多数据容器隔离。
- **JIT 与签名机制**：在 iOS 26 以下版本启用 JIT 后可跳过代码签名直接加载；在无 JIT 模式下会使用 LiveContainer 的签名证书为容器内应用进行本地重签。

> [!CAUTION]
> **关于第三方闭源修改版的安全提醒**  
> 所有安装进 LiveContainer 的应用都运行在同一个宿主容器沙盒内，容器本身可访问其中保存的 Keychain 与登录凭据。请务必只使用自己信任或自行编译的开源构建版本。

## 系统与环境要求

- **iOS / iPadOS 15+**（多窗口 / 多任务功能需要 **iOS / iPadOS 16.0+**）
- **AltStore 2.0+** / **SideStore 0.6.0+**（或直接安装合体版内置的 SideStore）

## 常用功能与使用指南

更多完整教程与常见问题可查看上游官方文档：[安装指南](https://livecontainer.github.io/docs/installation) · [常见问题 FAQ](https://livecontainer.github.io/docs/faq)

- **安装与启动应用**：打开 LiveContainer，点击右上角 `+` 选择 `.ipa` 文件安装；选中应用后下次启动生效，长按应用卡片可进入单独设置与数据容器管理。
- **添加到主屏幕**：支持生成桌面快捷启动方式（[文档说明](https://livecontainer.github.io/docs/guides/add-to-home-screen)）。
- **多开与多数据容器**：支持安装多个 LiveContainer 实例及为单个应用分配独立数据容器（[多开说明](https://livecontainer.github.io/docs/guides/multiple-livecontainers) · [多容器文档](https://livecontainer.github.io/docs/guides/containers-and-external-data)）。
- **多任务小窗 / 画中画 / 原生窗口**：长按应用横幅选择 **Multitask** 可同时运行多个应用，iPadOS 支持原生多窗口，可在设置中设为默认启动模式。需注意通过 SideStore / AltStore 安装时请勾选 **Keep App Extensions（保留应用扩展）**。
- **文件选择器与本地通知修复**：若容器内应用出现文件选择器打不开或无法申请通知权限，可在该应用的单独设置中分别开启「修复文件选择器」与「修复本地通知」。
- **「在应用中打开」与剪贴板 / 分享跳转**：支持通过 iOS 系统分享菜单或右上角链接按钮直接将 URL / 文件交给对应的容器内应用处理。

## 本地编译与打包

1. 克隆本仓库并在同级目录准备 `SideStore`（可直接使用 [`scripts/build_local.sh`](./scripts/build_local.sh) 自动拉取 [KSLengYu/SideStore-zh_CN](https://github.com/KSLengYu/SideStore-zh_CN) `LiveContainerSupport` 分支并完成编译打包）：
   ```bash
   bash scripts/build_local.sh
   ```
2. 编译输出位于 `dist/LiveContainer+SideStore.ipa` 与 `dist/SideStore-zh_CN.ipa`。

## 项目结构概览

- **Main executable（主程序）**：负责准备宿主运行环境、修正 Mach-O / `@executable_path` / `NSBundle.mainBundle` 并动态加载访客应用；未指定启动目标时进入 `LiveContainerSwiftUI`。
- **LiveContainerSwiftUI**：基于 SwiftUI 的主界面与多语言本地化模块（含 `Localizable.xcstrings`）。
- **MultitaskSupport**：多任务窗口管理支持（基于 [FrontBoardAppLauncher](https://github.com/khanhduytran0/FrontBoardAppLauncher)）。
- **SideStore**：合体版与 SideStore 续签集成逻辑。
- **TweakLoader**：随容器应用加载的插件注入器。
- **ZSign**：内置签名器（源自 [zhlynn/zsign](https://github.com/zhlynn/zsign) 与 [Feather](https://github.com/khcrysalis/Feather) 的修改版）。

## 开源协议与致谢

- 开源协议：[GNU Affero General Public License v3.0](https://github.com/LiveContainer/LiveContainer/blob/main/LICENSE)
- 上游项目与贡献者：[LiveContainer/LiveContainer](https://github.com/LiveContainer/LiveContainer)、[SideStore](https://github.com/SideStore/SideStore) 及原仓库致谢列表中的各位开发者（详见 [English README](./README_en.md#credits)）。
