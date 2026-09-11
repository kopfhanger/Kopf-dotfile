# Kopf-dotfile

个人 dotfiles 配置仓库，当前运行于 **CachyOS + Niri + Noctalia**。

## 🖥️ 当前环境

| 项目      | 内容                                         |
| --------- | -------------------------------------------- |
| **OS**    | CachyOS (Arch Linux 衍生)                    |
| **WM**    | Niri (滚动式平铺合成器)                      |
| **Shell** | Fish                                         |
| **终端**  | Foot (主力) + Ghostty (备选)                 |
| **主题**  | Noctalia v5 (原 noctalia-shell v4 已存档)      |
| **字体**  | Maple Mono NF CN (Nerd Font)                 |
| **配色**  | 内置多套配色方案 (via Noctalia)               |

## 📁 配置一览

### 窗口管理器

| 目录         | 说明                                                      |
| ------------ | --------------------------------------------------------- |
| `niri_arch/` | **当前主力** — Niri 配置 (Arch Linux + Noctalia 适配版)   |
| `niri_nix/`  | Niri 配置 (NixOS 26.11pre + Noctalia v5)                  |
| `misc/hyprland/`  | **储备** — Hyprland 配置 (模块化，含全套动画/装饰/键绑定) |

### 终端

| 目录         | 说明                                          |
| ------------ | --------------------------------------------- |
| `foot/`      | **主力终端** — CPU 渲染，轻量快速                 |
| `misc/ghostty/`   | 备选终端 — GPU 加速，配置自 foot 迁移 |
| `misc/wezterm/`   | 备选终端 — GPU 加速，Lua 配置，支持连字            |
| `misc/kitty/`     | 备选终端 — 含 kitty-themes 主题包                 |
| `misc/alacritty/` | 备选终端 — OpenGL 加速                            |

### 主题与外观

| 目录          | 说明                                          |
| ------------- | --------------------------------------------- |
| `noctalia/`    | **Noctalia v5** TOML 配置 (独立二进制，非 quickshell) |
| `fastfetch/`  | 系统信息展示 (带自定义 ASCII logo)            |
| `fontconfig/` | 字体渲染配置                                  |
| `misc/hyprland/waybar/` | 状态栏 (Hyprland 用，Niri 下由 Noctalia bar 代替)  |

### Shell

| 目录    | 说明                                                                 |
| ------- | -------------------------------------------------------------------- |
| `fish/` | Fish Shell 配置 (Tide 主题 / FZF / Zoxide / Sponge / Gitnow / fcitx) |

### 编辑器与文件管理

| 目录    | 说明                                |
| ------- | ----------------------------------- |
| `zed/`  | Zed 编辑器配置 + 主题               |
| `yazi/` | 终端文件管理器 (含插件/主题/快捷键) |

### 系统工具

| 目录                | 说明                    |
| ------------------- | ----------------------- |
| `btop/`             | 系统资源监控            |
| `misc/cava/`             | 终端音频可视化          |
| `misc/mpd/` + `misc/ncmpcpp/` | 音乐播放服务端 + 客户端 |
| `misc/mpv/`              | 视频播放器配置          |
| `swappy/`           | 截图编辑工具            |

### 其他

| 目录          | 说明                            |
| ------------- | ------------------------------- |
| `misc/noctalia_v4/` | Noctalia v4 配置存档 (JSON/QML，待 v5 稳定后清除) |
| `nixos/`      | NixOS 26.11pre 配置 (GDM + GNOME/Niri，Home Manager 26.05) |

## 🔧 快速部署

1. **克隆仓库**

    ```bash
    git clone https://github.com/Kopfhanger/Kopf-dotfile ~/workspace/Kopf-dotfile
    ```

2. **创建符号链接（整个文件夹级联）**

    > ⚠️ 先备份原有的配置目录：`mv ~/.config/niri ~/.config/niri.bak`

    ```bash
    # 窗口管理器
    ln -sfn ~/workspace/Kopf-dotfile/niri_arch  ~/.config/niri

    # Noctalia
    ln -sfn ~/workspace/Kopf-dotfile/noctalia   ~/.config/noctalia

    # 终端
    ln -sfn ~/workspace/Kopf-dotfile/misc/ghostty    ~/.config/ghostty
    ln -sfn ~/workspace/Kopf-dotfile/foot       ~/.config/foot

    # Shell
    ln -sfn ~/workspace/Kopf-dotfile/fish       ~/.config/fish

    # 编辑器
    ln -sfn ~/workspace/Kopf-dotfile/zed        ~/.config/zed
    ln -sfn ~/workspace/Kopf-dotfile/yazi       ~/.config/yazi

    # 系统工具
    ln -sfn ~/workspace/Kopf-dotfile/btop       ~/.config/btop
    ln -sfn ~/workspace/Kopf-dotfile/fastfetch  ~/.config/fastfetch
    ln -sfn ~/workspace/Kopf-dotfile/swappy     ~/.config/swappy

    # Hyprland（如果使用）
    ln -sfn ~/workspace/Kopf-dotfile/misc/hyprland   ~/.config/hypr
    ```

3. **安装必要依赖**
    ```bash
    # 终端
    sudo pacman -S ghostty foot
    # 其他工具按需安装
    ```

## ⌨️ 快捷键设计原则

由于同时维护了 **Niri** 和 **Hyprland** 两套 WM 配置，终端快捷键在设计时避开了两者共用的 Super 组合键：

- **Super+字母** → 留空给 WM 使用
- **Ctrl+Shift+字母** → 终端内复制/粘贴/全选
- **Alt+数字** → 切换标签页 (不与 WM 的工作区冲突)
- **Super+Alt+字母** → 终端的专属操作 (分屏/跳转等)

详细快捷键见各配置文件内的注释说明。

## 📝 备注

- `niri_arch/` 是当前活跃的 WM 配置，`misc/hyprland/` 作为储备保留
- `noctalia/` 是 v5 配置 (TOML 格式)，旧版 v4 JSON 配置已存档于 `misc/noctalia_v4/`
- 所有配置文件的注释均中文化，方便查阅
