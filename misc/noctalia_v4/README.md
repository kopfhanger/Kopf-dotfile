# Noctalia v4 配置存档

这是旧版 **noctalia-shell v4.7.7** 的配置存档。

## 存档缘由

2025年7月升级到 **Noctalia v5.0.0_beta2**（包名从 `noctalia-shell` 改为 `noctalia`），
v5 是完全重写版，配置格式从 JSON 改为 TOML，不再兼容 v4 配置。

此目录保留全部 v4 配置以备回退：
- `settings.json` — v4 GUI 设置
- `plugins.json` / `plugins/` — v4 QML 插件（v5 不兼容）
- `colors.json` / `colorschemes/` — v4 配色方案（v5 内置）

## 回退方式

如果需要回退到 v4：

```bash
# 停止当前 noctalia（v5）
killall noctalia

# 切换符号链接
rm ~/.config/noctalia

# 恢复 v4
mv ~/workspace/Kopf-dotfile/noctalia_v4 ~/workspace/Kopf-dotfile/noctalia
ln -sfn ~/workspace/Kopf-dotfile/noctalia ~/.config/noctalia

# 恢复 niri 配置中的启动命令和 IPC 调用
# （恢复 config.kdl 和 binds.kdl 中 v5 相关的改动）
```

清除计划：等 v5 稳定版发布后清理此目录。
