-- =====================================================================
-- WezTerm 终端配置
-- =====================================================================
-- 终端：https://wezfurlong.org/wezterm
-- 配置参考：https://wezfurlong.org/wezterm/config/files.html
--
-- 从 foot 配置迁移，字体、配色、透明度完全复刻。
-- 显示环境：CachyOS + Niri (Noctalia)
-- 主字体：Maple Mono NF CN (Nerd Font)
-- =====================================================================

local wezterm = require 'wezterm'
local config = {}

-- =====================================================================
-- 字体
-- =====================================================================
-- Maple Mono NF CN — Nerd Font 等宽字体，含完整图标集
config.font = wezterm.font('Maple Mono NF CN', { weight = 'Regular' })
config.font_size = 12.0

-- =====================================================================
-- 窗口外观
-- =====================================================================
-- 背景色（复刻 foot: background=000000, alpha=0.85）
-- 背景模糊（需要 compositor 支持 ext-background-effect）
config.background = {
    {
        source = {
            Color = '#000000',
        },
    },
}
config.window_background_opacity = 0.85
config.window_background_blur = true

-- 窗口内边距
config.window_padding = {
    left = 2,
    right = 2,
    top = 2,
    bottom = 2,
}

-- 隐藏鼠标指针（输入时）
config.hide_mouse_cursor_when_typing = true

-- 关闭窗口确认提示（有未关闭的标签/分屏时）
config.window_close_confirmation = 'NeverPrompt'

-- =====================================================================
-- 16 色 ANSI 调色板
-- =====================================================================
-- 配色完全复刻自 foot 配置，保持终端颜色一致性
config.colors = {
    foreground = '#dddddd',
    background = '#000000',
    cursor_bg = '#dddddd', -- 光标背景色
    cursor_border = 'white',

    -- 深色 8 色
    ansi = {
        '#000000', -- black       — 黑色
        '#cc0403', -- red         — 红色
        '#19cb00', -- green       — 绿色
        '#cecb00', -- yellow      — 黄色
        '#0d73cc', -- blue        — 蓝色
        '#cb1ed1', -- magenta     — 洋红
        '#0dcdcd', -- cyan        — 青色
        '#dddddd', -- white       — 白色
    },

    -- 亮色 8 色（加粗变体）
    brights = {
        '#767676', -- bright black       — 亮黑（灰色）
        '#f2201f', -- bright red         — 亮红
        '#23fd00', -- bright green       — 亮绿
        '#fffd00', -- bright yellow      — 亮黄
        '#1a8fff', -- bright blue        — 亮蓝
        '#fd28ff', -- bright magenta     — 亮洋红
        '#14ffff', -- bright cyan        — 亮青
        '#ffffff', -- bright white       — 亮白
    },
}

-- 加粗文本使用亮色（类似 foot 的 bold-text-in-bright=yes）
config.bold_brightens_ansi_colors = true

-- =====================================================================
-- 光标样式
-- =====================================================================
-- foot 默认 block 光标，这里保持一致
config.default_cursor_style = 'BlinkingBlock' -- 'Block' | 'BlinkingBlock' | 'Bar' | 'BlinkingBar'
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.cursor_blink_rate = 500 -- 闪烁间隔（毫秒）

-- =====================================================================
-- 标签栏
-- =====================================================================
-- 显示标签栏（多标签时方便切换）
config.enable_tab_bar = true
-- 标签栏位置
config.tab_bar_at_bottom = false

-- =====================================================================
-- 快捷键
-- =====================================================================
-- WezTerm 默认快捷键已较完善，保持默认即可。
-- 常用默认快捷键：
--   Ctrl+Shift+c        — 复制
--   Ctrl+Shift+v        — 粘贴
--   Ctrl+Shift+t        — 新标签页
--   Ctrl+Tab            — 下一个标签页
--   Ctrl+Shift+Tab      — 上一个标签页
--   Alt+数字             — 跳转到指定标签页
--   Ctrl+Shift+方向键    — 调整标签页顺序
--   Ctrl+Shift+u        — 进入 URL 选择模式
--   Ctrl+加号/减号/0     — 放大/缩小/重置字体

config.keys = {
    -- ... 其他快捷键

    -- Ctrl+Backspace 映射为 Ctrl+W (删除左侧单词)
    {
        key = 'Backspace',
        mods = 'CTRL',
        action = wezterm.action.SendKey { key = 'w', mods = 'CTRL' },
    },
    -- Ctrl+Delete 映射为 Alt+D (删除右侧单词)
    {
        key = 'Delete',
        mods = 'CTRL',
        action = wezterm.action.SendKey { key = 'd', mods = 'ALT' },
    },
}

-- =====================================================================
-- 其他杂项
-- =====================================================================

-- 默认 Shell（nil = 使用系统默认）
-- config.default_prog = {}

-- 自动重新加载配置（保存即生效）
config.automatically_reload_config = true

-- =====================================================================
-- 最后应用配置
-- =====================================================================
return config
