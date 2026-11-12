<div align="center">
   <img width="217" height="217" src="./screenshots/livecontainer_icon.png" alt="Logo">
</div>
   

<div align="center">
  <h1><b>LiveContainer + SideStore (zh-CN)</b></h1>
  <p><i>基于 LiveContainer 与 SideStore 的简体中文分支，支持应用内中英文切换（重启后生效） / Simplified Chinese branch of LiveContainer + SideStore with in-app language switching (restart required)</i></p>
</div>

> [!NOTE]
> **分支说明 / Branch Info**：  
> 本仓库是基于上游 [LiveContainer/LiveContainer](https://github.com/LiveContainer/LiveContainer) 的简体中文分支仓库；合体版内置的中文版 SideStore 来自 [KSLengYu/SideStore-zh_CN (`LiveContainerSupport` 分支)](https://github.com/KSLengYu/SideStore-zh_CN)。  
> This repository is a Simplified Chinese branch based on [LiveContainer/LiveContainer](https://github.com/LiveContainer/LiveContainer), bundled with the Chinese SideStore build from [KSLengYu/SideStore-zh_CN (`LiveContainerSupport`)](https://github.com/KSLengYu/SideStore-zh_CN).

## 本分支修改内容 / What's Changed

### 中文说明
- **LiveContainer 应用内语言切换（重启后生效）**：在 LiveContainer 设置页新增语言选择器（支持 `简体中文` / `English`），切换时不直接改写当前运行界面，而是自动弹出重启确认框并在页面内保留「需要重启应用（点击立即重启）」按钮，确认后自动重启并应用新语言。
- **SideStore 完整汉化与语言切换**：完整合入 SideStore 简体中文翻译并将字库打包至合体版 `LiveContainer.app` 中；SideStore「设置 → 个性化外观 → 语言」支持在 `简体中文` 与 `English` 间切换，同样在重启后生效并支持自动重开。
- **Apple ID 登录与异常恢复优化**：默认关闭存在兼容问题的设备端独立 Anisette，并在连续登录失败或遇到 `-80045` 异常时提供恢复弹窗（关闭设备端独立 Anisette 并重置 `adi.pb`）。
- **自动化打包与 GitHub Actions**：提供 [`scripts/build_local.sh`](./scripts/build_local.sh) 与 [`scripts/package_combined.sh`](./scripts/package_combined.sh)（搭配 [`scripts/merge_strings.py`](./scripts/merge_strings.py)），云端工作流自动编译输出 **`LiveContainer+SideStore.ipa`** 与独立版 **`SideStore-zh_CN.ipa`**（不生成单独版 LiveContainer IPA）并发布至 Releases。

### English Overview
- **In-App Language Switching for LiveContainer (Restart Required)**: Added an in-app language picker (`简体中文` / `English`) in LiveContainer Settings. Changes take effect after restart via a prompt alert and an inline restart button that automatically relaunches LiveContainer.
- **Full Simplified Chinese Localization & Language Switching for SideStore**: Embedded Simplified Chinese translations from [KSLengYu/SideStore-zh_CN](https://github.com/KSLengYu/SideStore-zh_CN) into the combined bundle; SideStore Settings also supports switching between `简体中文` and `English` (effective after restart).
- **Apple ID Sign-In & Recovery Improvements**: Improved `-80045` / Anisette compatibility and added a recovery alert after repeated sign-in failures to disable On-Device Anisette and reset `adi.pb`.
- **Automated Packaging & CI**: Includes local build scripts and GitHub Actions workflow outputting `LiveContainer+SideStore.ipa` and standalone `SideStore-zh_CN.ipa`.

---

以下为上游 LiveContainer 原版介绍与使用文档：

<div align="center">
  <h1><b>LiveContainer</b></h1>
  <p><i>An app launcher that runs iOS apps without actually installing them! </i></p>
</div>
<h6 align="center">

Crowdin Project: [![Crowdin](https://badges.crowdin.net/livecontainer/localized.svg)](https://crowdin.com/project/livecontainer) &nbsp;| &nbsp; Documentation:[livecontainer.github.io](https://livecontainer.github.io/docs/intro)

# LiveContainer

- LiveContainer is an app launcher (not emulator or hypervisor) that allows you to run iOS apps inside it.
- Allows you to install unlimited apps (3 app/10 app id free developer account limit does not apply here) with only one app & app id. You can also have multiple versions of an app installed with multiple data containers.
- (Below iOS 26) When JIT is available, codesign is entirely bypassed, no need to sign your apps before installing. Otherwise, your app will be signed with the same certificate used by LiveContainer.

> [!CAUTION]
> **Important Notice Regarding Third-Party Builds of LiveContainer**
>
> We have recently noticed the appearance of certain closed-source third-party builds of LiveContainer. Please be aware that all your apps are installed within LiveContainer, which means these third-party builds **have full access to your data, including sensitive information such as keychain items and login credentials**. 
> 
> Furthermore, please note that we do not provide any support for issues of these third-party builds.


# Installation
**LiveContainer comes with a standalone version and a version with built-in SideStore. [Please read the install guide here](https://livecontainer.github.io/docs/installation)**

If you encounter any issue please [read our FAQ here](https://livecontainer.github.io/docs/faq)

### Standalone 
<table>
<tr>
<td>
Stable
</td>
<td>
<a href="https://stikstore.app/altdirect/?url=https://github.com/LiveContainer/LiveContainer/releases/download/1.0/apps.json&exclude=livecontainer" target="_blank">
   <img src="https://raw.githubusercontent.com/StikStore/altdirect/refs/heads/main/assets/png/AltSource_Blue.png" alt="Add AltSource" width="200"/>
</a>
</td>
<td>
<a href="https://github.com/LiveContainer/LiveContainer/releases/latest/download/LiveContainer.ipa" target="_blank">
   <img src="https://raw.githubusercontent.com/StikStore/altdirect/refs/heads/main/assets/png/Download_Blue.png" alt="Download .ipa" width="200"/>
</a>
</td>
</tr>
<tr>
<td>
Nightly
</td>
<td>
<a href="https://stikstore.app/altdirect/?url=https://github.com/LiveContainer/LiveContainer/releases/download/nightly/apps_nightly.json&exclude=livecontainer" target="_blank">
   <img src="https://raw.githubusercontent.com/StikStore/altdirect/refs/heads/main/assets/png/AltSource_Blue.png" alt="Add AltSource" width="200"/>
</a>
</td>
<td>
<a href="https://github.com/LiveContainer/LiveContainer/releases/download/nightly/LiveContainer.ipa" target="_blank">
   <img src="https://raw.githubusercontent.com/StikStore/altdirect/refs/heads/main/assets/png/Download_Blue.png" alt="Download .ipa" width="200"/>
</a>
</td>
</tr>
</table>

### LiveContainer+SideStore
|Stable|Nightly|
|:-:|:-:|
|<a href="https://github.com/LiveContainer/LiveContainer/releases/latest/download/LiveContainer+SideStore.ipa" target="_blank"><img src="https://raw.githubusercontent.com/StikStore/altdirect/refs/heads/main/assets/png/Download_Blue.png" alt="Download .ipa" width="200" /></a>|<a href="https://github.com/LiveContainer/LiveContainer/releases/download/nightly/LiveContainer+SideStore.ipa" target="_blank"><img src="https://raw.githubusercontent.com/StikStore/altdirect/refs/heads/main/assets/png/Download_Blue.png" alt="Download .ipa" width="200" /></a>|


## Requirements

- iOS/iPadOS 15+
   + Multitasking requires iOS/iPadOS 16.0+
- AltStore 2.0+ / SideStore 0.6.0+


# Features & Guides

### Installing Apps
- Open LiveContainer, tap the plus icon in the upper right hand corner and select IPA files to install.
- Choose the app you want to open in the next launch.
- You can long-press the app to manage it.

### [Add Apps to Home Screen](https://livecontainer.github.io/docs/guides/add-to-home-screen)

### [Multiple LiveContainers](https://livecontainer.github.io/docs/guides/multiple-livecontainers)
Using multiple LiveContainers allows you to run multiples different apps simultaneously, with *almost* seamless data transfer between the LiveContainers.

### [Multitasking](https://livecontainer.github.io/docs/guides/multitask)
You can now launch multiple apps simultaneously in in-app virtual windows. These windows can be resized, scaled, and even displayed using the native Picture-in-Picture (PiP) feature. On iPads, apps can run in native window mode, displaying each app in a separate system window. And if you wish, you can choose to run apps in multitasking mode by default in settings.

To use multitasking, hold its banner and tap **"Multitask"**. You can also make Multitask the default launch mode in settings.

>[!Note]
>1. To use multitasking, ensure you select **"Keep App Extensions"** when installing via SideStore/AltStore.  
>2. If you want to enable JIT for multitasked apps, you’ll need a JIT enabler that supports attaching by PID. (StikDebug)

### [JIT Support](https://livecontainer.github.io/docs/guides/jit-support)
### [Installing external tweaks](https://livecontainer.github.io/docs/guides/tweaks)
### [Multiple Containers/External Containers](https://livecontainer.github.io/docs/guides/containers-and-external-data)
### [Hiding Apps](https://livecontainer.github.io/docs/guides/lock-app)

### Fix File Picker & Local Notification
Some apps may experience issues with their file pickers or not be able to apply for notification permission in LiveContainer. To resolve this, enable "Fix File Picker" & "Fix Local Notifications" accordingly in the app-specific settings.

### "Open In App" Support
- You can simply share a URL or a file to app simply by using iOS's native share sheet. In share sheet, select LiveContainer, and LiveContainer will ask you which app you'd like to open that URL/file in.
- What's more, you also can tap the link icon in the top-right corner of the "Apps" tab and input the URL. LiveContainer will detect the appropriate app and ask if you want to launch it.

## Compatibility
Unfortunately, not all apps work in LiveContainer, so we have a [compatibility list](https://github.com/LiveContainer/LiveContainer/labels/compatibility) to tell if there is apps that have issues. If they aren't on this list, then it's likely going run. However, if it doesn't work, please make an [issue](https://github.com/LiveContainer/LiveContainer/issues/new/choose) about it.

## Building
Open Xcode, edit `DEVELOPMENT_TEAM[config=Debug]` in `xcconfigs/Global.xcconfig` to your team id and compile.

## Project structure
### Main executable
- Core of LiveContainer
- Contains the logic of setting up guest environment and loading guest app.
- If no app is selected, it loads LiveContainerSwiftUI.

### LiveContainerSwiftUI
- SwiftUI rewrite of LiveContainerUI (by @hugeBlack)
- Language file `Localizable.xcstrings` is in here for multilingual support. To help us translate LiveContainer, please visit [our crowdin project](https://crowdin.com/project/livecontainer)

### MultitaskSupport
- Contains the implementation of multitasking feature.
- Based on [FrontBoardAppLauncher](https://github.com/khanhduytran0/FrontBoardAppLauncher)

### SideStore
- Supporting code for SideStore's app refreshing integration

### TweakLoader
- A simple tweak injector, which loads CydiaSubstrate and loads tweaks.
- Injected to every app you install in LiveContainer.

### ZSign
- The app signer shipped with LiveContainer.
- Originally made by [zhlynn](https://github.com/zhlynn/zsign).
- LiveContainer uses [Feather's](https://github.com/khcrysalis/Feather) version of ZSign modified by khcrysalis.
- Changes are made to meet LiveContainer's needs.

## How does it work?

### Patching guest executable
- Patch `__PAGEZERO` segment:
  + Change `vmaddr` to `0xFFFFC000` (`0x100000000 - 0x4000`)
  + Change `vmsize` to `0x4000`
- Change `MH_EXECUTE` to `MH_DYLIB`.
- Inject a load command to load `TweakLoader.dylib`

### Patching `@executable_path`
- Hook `dyld4::APIs::_NSGetExecutablePath`
- Call `_NSGetExecutablePath`
- Replace `config.process.mainExecutablePath`
  - Calculate address of `config.process.mainExecutablePath` using `dyld4::APIs` instance (passed as first parameter)
  - Use `builtin_vm_protect` or TPRO unlock to make it writable
  - Replace the address with one we have control of
- Put the original `dyld4::APIs::_NSGetExecutablePath` back

> Old Method
>- Call `_NSGetExecutablePath` with an invalid buffer pointer input -> SIGSEGV
>- Do some [magic stuff](https://github.com/khanhduytran0/LiveContainer/blob/5ef1e6a/main.m#L74-L115) to overwrite the contents of executable_path.

### Patching `NSBundle.mainBundle`
- This property is overwritten with the guest app's bundle.

### Bypassing Library Validation
- JIT is optional to bypass codesigning. In JIT-less mode, all executables are signed so this does not apply.
- Derived from [Restoring Dyld Memory Loading](https://blog.xpnsec.com/restoring-dyld-memory-loading)

### dlopening the executable
- Call `dlopen` with the guest app's executable
- TweakLoader loads all tweaks in the selected folder
- Find the entry point
- Jump to the entry point
- The guest app's entry point calls `UIApplicationMain` and start up like any other iOS apps.

### Multi-Account support & Keychain Semi-Separation
[128 keychain access groups](./entitlements.xml) are created and LiveContainer allocates them randomly to each container of the same app. So you can create 128 container with different keychain access groups.

## Limitations
- Entitlements from the guest app are not applied to the host app. This isn't a big deal since sideloaded apps requires only basic entitlements.
- App Permissions are globally applied.
- Guest app containers are not sandboxed. This means one guest app can access other guest apps' data.
- App extensions aren't supported. they cannot be registered because: LiveContainer is sandboxed, SpringBoard doesn't know what apps are installed in LiveContainer, and they take up App ID.
- Multitasking can be achieved by using multiple LiveContainer and the multitasking feature. However, while we were able to fix physical keyboard input issue on iPadOS (https://github.com/LiveContainer/LiveContainer/issues/524), iPhone Mirroring uses different checks which still broke it (https://github.com/LiveContainer/LiveContainer/issues/793).
- Remote push notification will not work
- Querying custom URL schemes might not work(?)

## TODO
- Use ChOma instead of custom MachO parser

## License
[GNU Affero General Public License v3.0](https://github.com/LiveContainer/LiveContainer/blob/main/LICENSE)

## Credits
- [xpn's blogpost: Restoring Dyld Memory Loading](https://blog.xpnsec.com/restoring-dyld-memory-loading)
- [LinusHenze's CFastFind](https://github.com/pinauten/PatchfinderUtils/blob/master/Sources/CFastFind/CFastFind.c): [MIT license](https://github.com/pinauten/PatchfinderUtils/blob/master/LICENSE)
- [litehook](https://github.com/opa334/litehook): [MIT license](https://github.com/opa334/litehook/blob/main/LICENSE)
- @haxi0 & @m1337v for icon
- @Vishram1123 for the initial shortcut implementation.
- @hugeBlack for SwiftUI contribution
- @Staubgeborener for automatic AltStore/SideStore source updater
- @fkunn1326 for improved app hiding
- @slds1 for dynamic color feature
- @Vishram1123 for iOS 26+ JIT Script Support
- @StephenDev0 for AltStore source support
