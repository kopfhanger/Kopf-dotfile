{ config, pkgs, ... }:

{
# 安装 firefox.
  #programs.firefox.enable = true;

# 安装 flatpak
  services.flatpak.enable = true;

  # 系统级包已统一到 configuration.nix 的 environment.systemPackages
  # 此处仅保留程序启用配置

 programs.fish.enable = true;
 programs.nix-ld.enable = true;
 # programs.thunar.enable = true;
 programs.zoxide.enable = true;     # z 跳转
 programs.neovim.enable = true;     # 终端文本编辑器
 programs.yazi.enable = true;       # 终端文件管理器
 programs.nautilus-open-any-terminal = {  # 在 nautilus 中打开终端
   enable = true;
   terminal = "foot";
 };
 # programs.steam.enable = true;      # steam

 programs.thunar.plugins = with pkgs; [
   thunar-archive-plugin
   thunar-volman
 ];

  # 系统级包已统一到 configuration.nix 的 environment.systemPackages
}
