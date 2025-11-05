# FFmpeg Static Builds

基于 [FFmpeg-Builds](https://github.com/BtbN/FFmpeg-Builds) 的自动化构建项目。

提供 Windows (x64/arm64) 和 Linux (x64/arm64) 平台的 FFmpeg 静态构建版本。

Windows 构建目标为 Windows 10 22H2 及更新版本。

Linux 构建目标为 RHEL/CentOS 8 (glibc-2.28 + linux-4.18) 及更新版本。

## 版本说明

本项目遵循 FFmpeg 官方版本号，提供稳定版本的构建，**不提供每日构建版本**。

当前支持的版本：

- FFmpeg 6.1
- FFmpeg 7.1
- FFmpeg 8.0

## Release 命名规范

所有发布的构建产物遵循标准命名规范：

```
ffmpeg-<version>-<platform>-<arch>-<license>-<optional_info>.tar.xz
```

### 字段说明

- **`<version>`**: FFmpeg 版本号（如 `6.1`, `7.1`, `8.0`）
- **`<platform>`**: 操作系统平台
  - `win32` - Windows（所有架构统一使用 win32）
  - `linux` - Linux
- **`<arch>`**: 系统架构
  - `x64` - 64位 x86 架构
  - `arm64` - 64位 ARM 架构
- **`<license>`**: 许可证类型
  - `gpl` - GNU General Public License（包含所有依赖库，如 x264、x265）
  - `lgpl` - Lesser General Public License（不含 GPL-only 库）
- **`<optional_info>`**: 可选信息（如果没有则省略此字段）
  - `shared` - 共享库版本（包含 libav* 动态库）
  - 静态版本默认省略此字段

### 命名示例

- `ffmpeg-6.1-win32-x64-gpl-shared.tar.xz` - Windows 64位，GPL 许可证，共享库版本
- `ffmpeg-6.1-linux-x64-lgpl.tar.xz` - Linux 64位，LGPL 许可证，静态版本
- `ffmpeg-6.1-win32-arm64-gpl.tar.xz` - Windows ARM64，GPL 许可证，静态版本

SHA256 校验文件命名格式：`ffmpeg-<version>.sha256.txt`

## 面向人群

⚠️ **本项目主要面向自动化场景和 CI/CD 集成**

如果您是普通用户，建议使用上游项目：

- [BtbN/FFmpeg-Builds](https://github.com/BtbN/FFmpeg-Builds) - 提供每日构建和更完善的支持

## Package List

For a list of included dependencies check the scripts.d directory.
Every file corresponds to its respective package.

## How to make a build

### Prerequisites

- bash
- docker

### Build Image

- `./makeimage.sh target variant [addin [addin] [addin] ...]`

### Build FFmpeg

- `./build.sh target variant [addin [addin] [addin] ...]`

On success, the resulting zip file will be in the `artifacts` subdir.

### Targets, Variants and Addins

Available targets:
- `win64` (x86_64 Windows)
- `win32` (x86 Windows)
- `linux64` (x86_64 Linux, glibc>=2.28, linux>=4.18)
- `linuxarm64` (arm64 (aarch64) Linux, glibc>=2.28, linux>=4.18)

The linuxarm64 target will not build some dependencies due to lack of arm64 (aarch64) architecture support or cross-compiling restrictions.

- `davs2` and `xavs2`: aarch64 support is broken.
- `libmfx` and `libva`: Library for Intel QSV, so there is no aarch64 support.

Available variants:
- `gpl` Includes all dependencies, even those that require full GPL instead of just LGPL.
- `lgpl` Lacking libraries that are GPL-only. Most prominently libx264 and libx265.
- `nonfree` Includes fdk-aac in addition to all the dependencies of the gpl variant.
- `gpl-shared` Same as gpl, but comes with the libav* family of shared libs instead of pure static executables.
- `lgpl-shared` Same again, but with the lgpl set of dependencies.
- `nonfree-shared` Same again, but with the nonfree set of dependencies.

All of those can be optionally combined with any combination of addins:
- `4.4`/`5.0`/`5.1`/`6.0`/`6.1`/`7.0`/`7.1` to build from the respective release branch instead of master.
- `debug` to not strip debug symbols from the binaries. This increases the output size by about 250MB.
- `lto` build all dependencies and ffmpeg with -flto=auto (HIGHLY EXPERIMENTAL, broken for Windows, sometimes works for Linux)
