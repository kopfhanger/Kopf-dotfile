{ config, pkgs, ... }:

{
# 安装 firefox.
  #programs.firefox.enable = true;

# 安装 flatpak
  services.flatpak.enable = true;

  # 系统级包已统一到 configuration.nix 的 environment.systemPackages
  # 此处仅保留程序启用配置

 programs.nix-ld.enable = true;
 # programs.thunar.enable = true;
 programs.zoxide.enable = true;     # z 跳转
 programs.neovim.enable = true;     # 终端文本编辑器
 programs.yazi.enable = true;       # 终端文件管理器
 programs.nautilus-open-any-terminal = {  # 在 nautilus 中打开终端
   enable = true;
   terminal = "foot";
 };
 programs.steam.enable = true;      # steam

 programs.fish = {
  enable = true;
  promptInit = ''
    if not set -q __fish_datadir
      set -l fish_bin (status fish-path)
      set -l prefix (dirname (dirname $fish_bin))
      if test -d $prefix/etc/fish
        set -g __fish_datadir $prefix/etc/fish
      else if test -d $prefix/share/fish
        set -g __fish_datadir $prefix/share/fish
      end
    end
  '';
};

 programs.thunar.plugins = with pkgs; [
   thunar-archive-plugin
   thunar-volman
 ];

  # 系统级包已统一到 configuration.nix 的 environment.systemPackages
}
