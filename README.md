# FFmpeg 静态构建(国内下载加速)

[![最新版本](https://img.shields.io/github/v/release/KarinJS/FFmpeg-Builds?label=%E6%9C%80%E6%96%B0%E7%89%88%E6%9C%AC)](https://github.com/KarinJS/FFmpeg-Builds/releases/latest)
[![国内镜像](https://img.shields.io/badge/%E5%9B%BD%E5%86%85%E9%95%9C%E5%83%8F-npmmirror-blue)](https://registry.npmmirror.com/binary.html?path=ffmpeg-builds/)

开箱即用的 FFmpeg 静态编译版，专门服务国内用户：

- **版本号与 FFmpeg 官方一一对应**（如 `v8.1.2` 就是官方 `n8.1.2` 的源码），官方发新版后自动跟进发布
- **国内 npmmirror（cnpm）镜像同步**，无需科学上网即可高速下载
- 覆盖 **Windows / Linux** 双平台、**x64 / ARM64** 双架构，静态与动态库版本齐全

源码来自 FFmpeg 官方仓库 [FFmpeg/FFmpeg](https://github.com/FFmpeg/FFmpeg)，构建体系基于 [BtbN/FFmpeg-Builds](https://github.com/BtbN/FFmpeg-Builds) 二次开发。

## 下载

| 渠道 | 地址 | 说明 |
| --- | --- | --- |
| 国内镜像（推荐） | <https://registry.npmmirror.com/binary.html?path=ffmpeg-builds/> | npmmirror 同步，国内直连高速 |
| GitHub Releases | <https://github.com/KarinJS/FFmpeg-Builds/releases> | 第一手发布渠道 |

每个版本附带 `ffmpeg-<版本号>.sha256.txt` 校验文件，下载后可校验完整性。

### 怎么选文件?

不确定下哪个的话，按下表对号入座（`<v>` 为版本号，如 `8.1.2`）：

| 你的情况 | 下载这个 |
| --- | --- |
| Windows 普通用户 / 命令行使用 | `ffmpeg-<v>-win32-x64-gpl.tar.xz` |
| Windows ARM 设备（如骁龙笔记本） | `ffmpeg-<v>-win32-arm64-gpl.tar.xz` |
| Linux 服务器（x86_64） | `ffmpeg-<v>-linux-x64-gpl.tar.xz` |
| Linux ARM 服务器 / 树莓派等 | `ffmpeg-<v>-linux-arm64-gpl.tar.xz` |
| 需要 libav* 动态库做二次开发 | 对应平台的 `-shared` 版本 |
| 商业闭源软件内嵌，担心 GPL 传染 | 对应平台的 `lgpl` 版本（不含 x264/x265 等 GPL 库） |

压缩包为 `.tar.xz` 格式：Linux 直接 `tar -xJf` 解压；Windows 可用 [7-Zip](https://www.7-zip.org/) 或系统自带 `tar` 命令解压。

## 支持平台

| 平台 | 架构 | 最低系统要求 |
| --- | --- | --- |
| Windows | x64 / arm64 | Windows 10 22H2 及以上 |
| Linux | x64 / arm64 | glibc ≥ 2.28、内核 ≥ 4.18（RHEL/CentOS 8 同代及以上） |

## 版本说明

本项目只构建 FFmpeg **官方正式版**，不提供每日构建（nightly）。当前跟踪的系列：

- FFmpeg 8.1（最新稳定系列）
- FFmpeg 8.0
- FFmpeg 7.1
- FFmpeg 6.1

版本对应规则：

- `vX.Y.Z` ↔ 官方 tag `nX.Y.Z`（如 `v8.1.2` ↔ `n8.1.2`）
- `vX.Y.0` ↔ 官方系列首个正式版 tag `nX.Y`（如 `v8.1.0` ↔ `n8.1`）

> 早期的两段式 Release（`v6.1` / `v7.1` / `v8.0` / `v8.1`）是当时 release 分支的快照构建，因镜像已同步而保留，**不再更新**，请改用三段式版本。

### 自动跟版

仓库内置定时任务（`check-upstream` workflow）每日检测 FFmpeg 官方新发布的正式版本，发现新版本自动构建发版，无需人工干预。新增系列（如未来的 9.0）只需在 `addins/` 添加分支映射并更新白名单。

### 老版本兼容性说明

较早的 patch 版本（tag 发布时间较久远）使用当前工具链重新构建时，会自动应用 `patches/ffmpeg/<版本>/` 下回移的官方修复补丁（均为 FFmpeg 官方 commit 原样回移，不改动功能逻辑）。

特例：`6.1.0` 与 `6.1.1` 因官方当时使用的 Vulkan 临时 API 已被现代驱动头文件移除，构建时禁用了 av1/h264/hevc 三项 Vulkan 解码硬件加速；如需该功能请使用 `6.1.2` 及以上版本。

## 产物命名规范

```
ffmpeg-<版本号>-<平台>-<架构>-<许可证>[-shared].tar.xz
```

| 字段 | 取值 | 说明 |
| --- | --- | --- |
| 版本号 | `8.1.2` 等 | 三段式，与官方一一对应 |
| 平台 | `win32` / `linux` | Windows 统一用 `win32`（含 64 位） |
| 架构 | `x64` / `arm64` | — |
| 许可证 | `gpl` / `lgpl` | `gpl` 含 x264、x265 等全部依赖；`lgpl` 不含 GPL 独占库 |
| `-shared` | 可选后缀 | 带 libav* 动态库；纯静态版无此后缀 |

示例：

- `ffmpeg-8.1.2-win32-x64-gpl.tar.xz` —— Windows x64、GPL、静态
- `ffmpeg-8.1.2-linux-x64-lgpl.tar.xz` —— Linux x64、LGPL、静态
- `ffmpeg-8.1.2-win32-arm64-gpl-shared.tar.xz` —— Windows ARM64、GPL、含动态库

## 内置依赖

GPL 版本内置 x264、x265、SVT-AV1、dav1d、VP8/VP9、opus、mp3lame 等主流编解码器与滤镜依赖，完整列表见 [`scripts.d/`](scripts.d/) 目录（每个脚本对应一个依赖包）。

注：ARM64 Linux 因上游依赖限制缺少少量组件（如 Intel QSV 相关的 libmfx/libva、davs2/xavs2）。

## 自行构建

需要 bash 与 docker 环境：

```bash
# 构建镜像
./makeimage.sh <目标平台> <变体> [附加项...]

# 构建 FFmpeg(产物输出到 artifacts/ 目录)
./build.sh <目标平台> <变体> [附加项...]

# 示例:构建 Windows x64 GPL 版的 FFmpeg 8.1.2
./build.sh win64 gpl 8.1.2
```

- 目标平台：`win64` / `winarm64` / `linux64` / `linuxarm64`
- 变体：`gpl` / `lgpl` / `gpl-shared` / `lgpl-shared`
- 附加项：
  - 三段式版本号（如 `8.1.2`）—— 精确构建官方对应 tag，自动复用所属系列的镜像与依赖
  - 两段式系列号（如 `8.1`）—— 构建对应 release 分支最新代码
  - `debug` —— 保留调试符号（体积增大约 250MB）

## 致谢

- [FFmpeg](https://ffmpeg.org/) —— 一切的源头
- [BtbN/FFmpeg-Builds](https://github.com/BtbN/FFmpeg-Builds) —— 本项目基于其构建体系，需要每日构建版的用户请移步
- [cnpm / npmmirror](https://github.com/cnpm) 团队 —— 提供国内镜像同步支持 🎉

## 许可证

构建脚本遵循本仓库 [LICENSE](LICENSE)；FFmpeg 产物的使用需遵循对应的 GPL / LGPL 许可证条款。
