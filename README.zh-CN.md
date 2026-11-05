<div align="center">

<a href="https://opencapture.org/openpocketcine/">
  <img src="docs/assets/icon.png" alt="OpenPocketCine 应用图标" width="96" height="96">
</a>

# OpenPocketCine

[English](README.md) | **简体中文**

**面向 DJI Osmo 的开源现场监视器。**<br>
在手机上实现专业示波器、曝光辅助、相机与云台控制、回放和 LUT 导出。
免费且开源。

[![CI](https://github.com/erik-sutton95/OpenPocketCine/actions/workflows/ci.yml/badge.svg)](https://github.com/erik-sutton95/OpenPocketCine/actions/workflows/ci.yml) [![Docs](https://img.shields.io/badge/docs-opencapture.org-blue)](https://opencapture.org/openpocketcine/docs/) [![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE) [![Discussions](https://img.shields.io/github/discussions/erik-sutton95/OpenPocketCine?logo=github&label=discussions)](https://github.com/erik-sutton95/OpenPocketCine/discussions)

[![Join the TestFlight](https://img.shields.io/badge/TestFlight-iPhone_%26_iPad-0D96F6?style=for-the-badge&logo=apple&logoColor=white)](https://testflight.apple.com/join/1tmt3aEB) [![Get it on Google Play](https://img.shields.io/badge/Google_Play-Android_beta-01875F?style=for-the-badge&logo=googleplay&logoColor=white)](https://play.google.com/store/apps/details?id=com.opencapture.openpocketcine&hl=en-US&ah=mXzHtdYCMQTB83vt0jIRLnOOZaA) [![Download APK](https://img.shields.io/badge/Download_APK-No_Play_Store-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://github.com/erik-sutton95/OpenPocketCine/releases/tag/sideload-v0.1.5-8)

[官网](https://opencapture.org/openpocketcine/) · [文档](https://opencapture.org/openpocketcine/docs/) · [路线图](https://github.com/erik-sutton95/OpenPocketCine/discussions/categories/ideas) · [报告问题](https://github.com/erik-sutton95/OpenPocketCine/issues/new?template=bug_report.yml)

<br>

<a href="https://opencapture.org/openpocketcine/">
  <img alt="横屏 iPhone 上的 OpenPocketCine 实时监看录制画面" src="docs/assets/screens/hero-monitor.webp" width="820">
</a>

</div>

> [!NOTE]
> 本文是英文原版 README 的简体中文翻译，更新可能略晚于英文版，以[英文版](README.md)为准。

<details>
<summary><strong>目录</strong></summary>

- [支持的相机](#支持的相机)
- [功能特性](#功能特性)
- [实际效果](#实际效果)
- [安装](#安装)
- [媒体报道](#媒体报道)
- [路线图](#路线图)
- [免费、开源、属于你](#免费开源属于你)
- [面向开发者](#面向开发者)
  - [技术栈](#技术栈)
  - [架构](#架构)
  - [从源码构建](#从源码构建)
  - [文档](#文档)
- [参与贡献](#参与贡献)
- [支持](#支持)
- [致谢](#致谢)
- [许可证](#许可证)

</details>

## 支持的相机

| | 相机 | 实时画面 | 相机控制 | 云台 | 备注 |
| :---: | --- | :---: | :---: | :---: | --- |
| <img src="docs/assets/screens/osmo-pocket-4p.webp" alt="Osmo Pocket 4 Pro" height="64"> | **Osmo Pocket 4 Pro** | ✅ | ✅ | ✅ | 主要测试机型。1×/3× 光学变焦，6×/12× 变焦。变焦时 D-Log2 会切换为 D-Log。 |
| <img src="docs/assets/screens/osmo-pocket-4-catalog.webp" alt="Osmo Pocket 4" height="64"> | **Osmo Pocket 4** | ✅ | ✅ | ✅ | 1×/2×/4× 变焦。 |
| <img src="docs/assets/screens/osmo-pocket-3.webp" alt="Osmo Pocket 3" height="64"> | **Osmo Pocket 3** | ✅ | ✅ | ✅ | 更宽的画幅与固件组合仍需测试。 |
| <img src="docs/assets/screens/osmo-nano.webp" alt="Osmo Nano" height="64"> | **Osmo Nano** | ✅ | ✅ | – | 定焦 1× 镜头，因此会隐藏变焦控制。 |
| <img src="docs/assets/screens/osmo-action-6.webp" alt="Osmo Action 6" height="64"> | **Osmo Action 6** | 🧪 | 🧪 | – | 根据该相机的抓包实现，尚未在真机上验证。新增 APERTURE（光圈）控制。 |

✅ 在 iOS 和 Android 上可用 · 🧪 已实现，但尚未在该相机上验证 · – 该相机不支持。
其他 Osmo 机型可能会出现在蓝牙扫描中；其他 Action 机型和 360° 实时画面尚未接入。

> [!WARNING]
> 相机控制是逆向工程实现的，可能并不完整。在完全信任连接之前，请先在相机机身上确认录制能够开始和停止。

## 功能特性

- **像调色师一样读画面。** 波形图、RGB 分量图、直方图和矢量示波器实时显示在你正在判断的画面旁边，可以任意拖动、调整大小。
- **在开拍前抓住曝光和焦点。** 伪彩色（CineStop 场景档位、Video、IRE 和 Limits）、斑马纹、Traffic Lights（红绿灯曝光提示）、峰值对焦、EV 表、ND 建议，以及 LEVEL 横滚 / 俯仰仪。
- **一次构图，适配所有交付格式。** 网格、画幅参考线和中心十字线，横屏和竖屏都可用。
- **用手机操控相机。** 录制、ISO、快门、白平衡、EV、变焦和 FORMAT（格式）。点一下画面中的人脸，即可启动相机的主体追踪。
- **操控云台。** 屏幕虚拟摇杆或游戏手柄，Direction Lock（方向锁定）、Double-tap Level（双击回平），以及实验性的 Motion Control（运动控制）运镜。
- **同时监看多台相机。** 实验性的 Multiview（多机同屏）可将最多四台 Osmo 相机放在同一屏幕上，每台相机可单独套用 LUT，并支持分组录制。
- **收工前先检查素材。** 浏览相机里的视频片段和照片，给保留的素材打星，删除废片，并用与实时画面相同的示波器和辅助工具回放。
- **带着调色成片交付。** 内置或自定义 `.cube` LUT，导出时转换 Log、原生分享，以及可选的 [Frame.io](https://www.frame.io/) 上传（使用你自己的 Adobe 应用密钥）。

iPhone 和 iPad 是日常主力。Android 已有监视器、辅助工具、相机与云台控制、Multiview 和回放。**目前仅 iOS 支持：** 导出时 baked LUT（烧录 LUT）和 Convert log（转换 Log）、Frame.io 上传、向其他设备共享实时画面、Apple Watch、AirPods 头部追踪，以及每台相机的 Wi-Fi 和热点设置。

## 实际效果

<table>
  <tr>
    <td width="50%" valign="top">
      <a href="https://opencapture.org/openpocketcine/"><img alt="带有人脸追踪的实时监看画面，可锁定云台跟随" src="docs/assets/screens/face-tracking.webp"></a>
      <br><strong>人脸锁定。</strong> 点一下画面中的人脸，即可启动相机的主体追踪，同时直方图、斑马纹和 LUT 保持开启。
    </td>
    <td width="50%" valign="top">
      <a href="https://opencapture.org/openpocketcine/#scopes"><img alt="实时画面上的波形图和 Traffic Lights" src="docs/assets/screens/scopes.webp"></a>
      <br><strong>示波器。</strong> 波形图、RGB 分量图、直方图和矢量示波器显示在画面旁边，Traffic Lights 直接叠加在画面上。
    </td>
  </tr>
  <tr>
    <td width="50%" valign="top">
      <a href="https://opencapture.org/openpocketcine/#controls"><img alt="录制时的相机控制与变焦" src="docs/assets/screens/camera-controls.webp"></a>
      <br><strong>相机控制。</strong> 录制、ISO、EV 和变焦，还可通过屏幕摇杆、游戏手柄或 AirPods 控制云台。
    </td>
    <td width="50%" valign="top">
      <a href="https://opencapture.org/openpocketcine/#media"><img alt="iPhone 上的媒体库，显示相机里的视频片段和照片" src="docs/assets/screens/media-library.webp"></a>
      <br><strong>媒体库。</strong> 浏览相机里的视频片段和照片。收工前给保留的素材打星，删除废片。
    </td>
  </tr>
  <tr>
    <td width="50%" valign="top">
      <a href="https://opencapture.org/openpocketcine/#playback"><img alt="带完整监看辅助栏的片段回放" src="docs/assets/screens/media-playback-assists.webp"></a>
      <br><strong>回放。</strong> 与实时画面相同的示波器和辅助工具，高帧率片段按适配后的正常速度回放，导出时可烧录 LUT。
    </td>
    <td width="50%" valign="top" align="center">
      <a href="https://opencapture.org/openpocketcine/#vertical"><img alt="带斑马纹和构图工具的竖屏辅助栏" src="docs/assets/screens/vertical.webp" width="200"></a>
      <br><strong>竖屏。</strong> 完整的辅助栏在竖屏下同样可用。
    </td>
  </tr>
</table>

## 安装

| 平台 | 方式 | 备注 |
| --- | --- | --- |
| **iPhone 和 iPad** | [加入 TestFlight](https://testflight.apple.com/join/1tmt3aEB) | 一个通用 App。 |
| **Android** | [Google Play 公开测试版](https://play.google.com/store/apps/details?id=com.opencapture.openpocketcine&hl=en-US&ah=mXzHtdYCMQTB83vt0jIRLnOOZaA) | Android 10 或更高版本，arm64。 |
| **无 Play 商店的 Android** | [下载 APK 安装包](https://github.com/erik-sutton95/OpenPocketCine/releases/tag/sideload-v0.1.5-8)（**0.1.5 (8)**） | 适用于现场监视器和没有 Play 商店的设备。 |

> [!NOTE]
> 通过安装包安装的 APK 与 Google Play 安装的签名不同，两者无法互相更新。
> 安装 APK 之前，请先卸载 Play 版或 APK 镜像版。

配对和实时画面需要附近有一台真实相机。请参阅
[iOS](https://opencapture.org/openpocketcine/docs/apps/ios/) 和
[Android](https://opencapture.org/openpocketcine/docs/apps/android/) 指南，以及
[最新发布说明](https://opencapture.org/openpocketcine/docs/releases/0-1-5/)。

## 媒体报道

<table>
  <tr>
    <td width="33%" valign="top">
      <a href="https://www.cined.com/openpocketcine-free-open-source-field-monitor-app-brings-waveforms-false-color-and-luts-to-dji-osmo-cameras/"><img alt="CineD 文章" src="docs/assets/screens/press-cined.webp"></a>
      <br><strong>CineD</strong><br>Free open-source field monitor app brings waveforms, false color, and LUTs to DJI Osmo cameras
    </td>
    <td width="33%" valign="top">
      <a href="https://www.youtube.com/watch?v=8aMqWGNdKVU"><img alt="Colden Raisher 视频评测" src="docs/assets/screens/press-coldenraisher.webp"></a>
      <br><strong>Colden Raisher</strong><br>OpenPocketCine review: free pro monitor app for DJI Pocket 4P
    </td>
    <td width="33%" valign="top">
      <a href="https://www.youtube.com/watch?v=b7YqWULguxA"><img alt="Blue Field Studios 视频评测" src="docs/assets/screens/press-bluefieldstudios.webp"></a>
      <br><strong>Blue Field Studios</strong><br>Finally! Pocket 4P Cinema Features
    </td>
  </tr>
</table>

另有 [Newsshooter](https://www.newsshooter.com/2026/09/28/openpocketcine-free-field-monitor-for-dji-osmo-pocket-4-4p/)、
[Gadget Pilipinas](https://www.gadgetpilipinas.net/2026/08/openpocketcine-for-osmo-pocket/)
和 [Mark Exploring New Stuff](https://www.youtube.com/watch?v=cqGz6-kFcDA) 的报道。

## 路线图

路线图在 [GitHub Discussions](https://github.com/erik-sutton95/OpenPocketCine/discussions) 中。
浏览 [Ideas 分类](https://github.com/erik-sutton95/OpenPocketCine/discussions/categories/ideas)，
为想法投票、补充实际拍摄场景，或提议下一步要做的事。路线图讨论的是方向，不是承诺的上线日期。
工程阶段的细节见 [`docs/ROADMAP.md`](docs/ROADMAP.md)。

## 免费、开源、属于你

无订阅、无付费墙、无广告、无追踪。崩溃报告为自愿开启。
OpenPocketCine 采用 Apache-2.0 许可证，并与最新的前沿模型（Grok、Codex 和 Claude）一起公开构建，
让电影人和开发者可以检查、改进并改造他们所依赖的工具。
工程规范见 [`AGENTS.md`](AGENTS.md)。

## 面向开发者

### 技术栈

[![Swift](https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=swift&logoColor=white)](https://www.swift.org/) [![SwiftUI](https://img.shields.io/badge/SwiftUI-0D96F6?style=flat-square&logo=swift&logoColor=white)](https://developer.apple.com/xcode/swiftui/) [![Metal](https://img.shields.io/badge/Metal-555555?style=flat-square&logo=apple&logoColor=white)](https://developer.apple.com/metal/) [![Kotlin](https://img.shields.io/badge/Kotlin-7F52FF?style=flat-square&logo=kotlin&logoColor=white)](https://kotlinlang.org/) [![Jetpack Compose](https://img.shields.io/badge/Jetpack_Compose-4285F4?style=flat-square&logo=jetpackcompose&logoColor=white)](https://developer.android.com/compose) [![Vulkan](https://img.shields.io/badge/Vulkan-AC162C?style=flat-square&logo=vulkan&logoColor=white)](https://www.vulkan.org/)

### 架构

共享的 Swift 业务与协议核心，搭配各平台原生外壳：

| 层 | 路径 | 用途 |
| --- | --- | --- |
| **共享核心** | `Sources/OpenPocketViewCore/` | DUML 组帧、数据链路、BLE 广播、命令、状态 |
| **iOS 应用** | `ios/OpenPocketCine/` | SwiftUI 外壳、CoreBluetooth、热点配置、VideoToolbox |
| **Android 应用** | `Apps/Android/app/` | Jetpack Compose 手机外壳与 Android 平台适配层 |
| **Android 门面** | `Sources/OpenPocketCineAndroidFacade/` | Swift 会话与 Android 的 JNI 边界 |
| **测试** | `Tests/OpenPocketViewCoreTests/` | Swift Package 测试：组帧、传输、发现、布局 |

共享核心只负责协议逻辑，保持可移植（不依赖 SwiftUI、UIKit 或 Android）。
平台外壳负责网络接口、权限、生命周期、渲染和界面。详见
[`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md)。

### 从源码构建

构建工具通过 [`just`](https://github.com/casey/just) 运行：

```bash
just setup          # 安装 meta-check 工具（macOS / Homebrew）
just                # 列出所有 recipe
just check          # 运行仓库质量检查
just test           # 运行 Swift Package 测试
just native-check   # 运行 Swift 测试，然后构建并测试原生 iOS 应用
just android-check  # 构建、测试 Android 并做 lint
just handbook       # 文档见 http://127.0.0.1:4321/
```

iOS 的 Xcode 工程是生成的：

```bash
cd ios && xcodegen generate && open OpenPocketCine.xcodeproj
```

iOS 应用还需要共享的 OpenCine 包（`MonitorUI`、`MonitorPresentation`、
OpenCineCore 及其产品、OpenCineDJI、OpenCineMulticam），将其检出到本仓库旁边的
`../OpenCine`（`scripts/checkout-opencine.sh`）；`ios/project.yml` 通过路径引用它。

> [!TIP]
> 模拟器和安卓模拟器没有蓝牙，也没有相机 Wi-Fi。配对和实时画面需要一台
> 真实的 iPhone 或 Android 手机和一台相机。

发布：TestFlight 归档来自 Xcode Cloud（[`docs/testflight-ci.md`](docs/testflight-ci.md)）。
Play 封闭测试和安装包 APK 见 [`docs/android-play-ci.md`](docs/android-play-ci.md)。

### 文档

- **[文档](https://opencapture.org/openpocketcine/docs/)**：协议、iOS 和 Android 应用，以及如何构建。
  请在同一个 PR 里保持文档更新（[规范](https://opencapture.org/openpocketcine/docs/contribute/documentation/)）。
- [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md)：共享 Swift 核心与平台外壳
- [`docs/PARITY.md`](docs/PARITY.md)：iOS / Android 之间用户可见的功能对照
- [`docs/PERFORMANCE.md`](docs/PERFORMANCE.md)：实时链路 SLO（帧率、ACK、HUD）
- [`docs/UX.md`](docs/UX.md)：首次使用流程、操作文案、帮助、失败状态
- [`docs/RELEASE.md`](docs/RELEASE.md)：`main` + PR + `v*` 标签（不用 Git Flow）
- [`AGENTS.md`](AGENTS.md)：编码 agent 常驻索引

OpenPocketCine 在公开之前经历了较长的私有研发阶段；公开仓库从一个压缩后的初始提交开始，
而不是保留实验历史。

## 参与贡献

欢迎贡献。

- 请阅读 [`CONTRIBUTING.md`](CONTRIBUTING.md)，了解开发流程、代码规范，以及如何
  报告问题与提出功能需求。
- 问题请走 [GitHub 的问题报告表单](https://github.com/erik-sutton95/OpenPocketCine/issues/new?template=bug_report.yml)。
  请勿在 issue 中放入相机 Wi-Fi 密码或抓包数据。
- 想法和问题请去 **GitHub Discussions**：
  [Ideas](https://github.com/erik-sutton95/OpenPocketCine/discussions/categories/ideas) 和
  [Q&A](https://github.com/erik-sutton95/OpenPocketCine/discussions/categories/q-a)。
- 请阅读 [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md)。安全问题请参阅
  [`SECURITY.md`](SECURITY.md)。

<a href="https://github.com/erik-sutton95/OpenPocketCine/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=erik-sutton95/OpenPocketCine" alt="贡献者">
</a>

## 支持

衷心感谢每一位使用本项目、提交 issue 或发送补丁的朋友。可选的
[Buy Me a Coffee](https://buymeacoffee.com/eriksutton) 捐助有助于维持项目运转。如果你
更愿意捐给慈善机构，尤其是有助于动物的机构，同样欢迎。

## 致谢

我在学习 BLE 配对和相机 Wi-Fi 连接路径时，得到了
[Osmosis](https://github.com/KonradIT/osmosis)（Konrad Iturbe 开发的开源 Android 客户端，面向
Osmo 相机）的帮助，非常感谢。OpenPocketCine 是独立实现；Osmosis 是这一连接思路的灵感来源，
并非我复制的源码。如果你关心如何与 Osmo 相机对话，Konrad 的工作值得一看。

## 许可证

[Apache 2.0](LICENSE)。第三方许可证见
[`THIRD-PARTY-NOTICES.md`](THIRD-PARTY-NOTICES.md)。应用的隐私政策见
[opencapture.org/openpocketcine/privacy](https://opencapture.org/openpocketcine/privacy/)。

本项目与 SZ DJI Technology Co., Ltd.（大疆）无关，也未获得其背书。本项目不包含、不分发、
也不需要任何 DJI SDK 或专有文档。
“DJI”、“Osmo”、“Osmo Pocket”、“Osmo Action”、“Osmo Nano” 和 “Mimo” 是
SZ DJI Technology Co., Ltd. 的商标，仅在此用于识别。
