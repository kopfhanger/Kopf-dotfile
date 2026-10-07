{ config, pkgs, ... }:

{
  # Home Manager 现在自带 programs.noctalia 模块，会和下面通过
  # home-manager.sharedModules 引入的 noctalia 官方模块重复声明同名选项。
  # noctalia 官方模块其实已经写了 disabledModules，但写的是
  # "programs/noctalia.nix"，而 HM 是按目录 ./programs/noctalia 注册的
  # （key 不含 .nix），因此匹配不上。这里补上正确的相对路径。
  disabledModules = [ "programs/noctalia" ];

  home.username = "kopfhanger";
  home.homeDirectory = "/home/kopfhanger";

  # 让 NixOS 的 Niri 会话直接使用仓库中的模块化配置。
  home.file.".config/niri".source = ../niri_nix;

  # Noctalia v5 由 Home Manager 管理配置和包；仅在 Niri 会话中由 KDL 启动，
  # 因此登录 GNOME 时不会额外启动一套 shell。
  programs.noctalia = {
    enable = true;
    systemd.enable = false;
    settings = ../noctalia/config.toml;
  };

  home.packages = with pkgs;[
    appimage-run      # AppImage运行器
    nautilus          # 文件管理器
    code-nautilus     # 在此打开code
    qq                # qq
    swaylock          # 锁屏
    evince            # 文档查看器
    # obsidian          # 笔记管理软件
    thunderbird       # 邮件
    # drawio            # 绘图工具
    texliveFull       # latex
    vlc               # 媒体播放器
    thonny            # python开发环境
    # typora            # markdown编辑器
    loupe             # 屏幕缩放工具
    # listen1
    conda
    python3           # 编程
    python3Packages.pip # 包管理
    gnuplot
    ocrmypdf
    # jujutsu
    texstudio
    # kazumi
    # telegram-desktop
    gimp
    qbittorrent
    mission-center
    inkscape
    blender
    libreoffice-stable
    # lutris
    # protonplus
    # umu-launcher
    nix-output-monitor
    freefilesync
    microsoft-edge
    google-chrome
    obs-studio
    # zotero
    # xournalpp
    wpsoffice-cn
    pdfarranger
    # freecad
    julia
    # paraview
    wechat-uos
    zola
    gh
    rio
    spotify
    zathura
    tinymist
    typst
    wechat-uos

    # Tolaria：Markdown 知识库桌面应用（官方 AppImage 包装，定义见 ./pkgs/tolaria.nix）
    (pkgs.callPackage ./pkgs/tolaria.nix { })
  ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
   flake = "/etc/nixos/"; # 为您设置 NH_OS_FLAKE 环境变量
  };

  # programs.vscode.enable = true;    # 代码编辑器
  programs.foot.enable = true;      # 终端
  programs.satty.enable = true;

  programs.zed-editor = {
    enable = true;
    # package = pkgs.zed-editor.overrideAttrs (old: {
    #   doCheck = false;
    # });
  };

  programs.git = {
    enable = true;
    settings.user.name = "kopfhanger";
    settings.user.email = "xinyangzengyike@qq.com";
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.adw-gtk3;
     name = "adw-gtk3-dark";
    };
    iconTheme = {
      # 确保 name 与 package 生成的图标主题名称一致
     name = "Papirus";   # 根据你选择的 flavor 可能为 Papirus-Light 或 Papirus
      package = pkgs.catppuccin-papirus-folders.override {
       flavor = "latte";
        accent = "yellow";
      };
    };
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
     color-scheme = "prefer-dark";
    };
  }; # 为nautilus配置主题

  qt.enable = true;
  qt.style.name = "adwaita-dark";

  # home.backupFileExtension = "bak";
  # Home Manager 26.05 与 NixOS 26.11pre 的版本线独立维护。
  home.enableNixpkgsReleaseCheck = false;
  home.stateVersion = "26.05";
}
