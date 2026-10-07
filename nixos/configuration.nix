# 编辑此配置文件以定义应在您的系统上安装的内容。
# 帮助信息可在 configuration.nix(5) 手册页
# 及 NixOS 手册中找到（可通过运行 ‘nixos-help’ 访问）。

{ inputs, config, pkgs, lib, ... }:

{
  imports =
    [ # 包括硬件扫描的结果。
      ./hardware-configuration.nix
    ];

  # 启动引导器.
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";       # UEFI 固定写法
    theme = inputs.nixos-grub-themes.packages.${pkgs.stdenv.hostPlatform.system}.nixos;
    useOSProber = true;     # 自动探测其他系统
    gfxmodeEfi = "auto";    # 自动检测最佳分辨率
  };
  boot.loader.timeout = 5;

  boot.supportedFilesystems = [
    "ntfs"          # Windows 文件系统
    "btrfs"         # 一些 Linux 发行版使用
    "ext4"          # 标准 Linux 文件系统
    "vfat"          # EFI 分区
    # "apfs"       # 苹果系统分区 - 与最新内核 (6.19+) 不兼容，暂时禁用
  ];

  # 使用最新内核
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # 定义主机名.
  # networking.wireless.enable = true;  # 通过 wpa_supplicant 启用无线网络支持.

  # 如有需要配置网络代理
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # 启动蓝牙
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
  };

  # 启动网络
  networking.networkmanager.enable = true;

  # 设置时区
  time.timeZone = "Asia/Shanghai";

  # 选择国际化属性
  i18n.defaultLocale = "zh_CN.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  # 配置X11中的按键映射
  services.xserver.xkb = {
    layout = "cn";
    variant = "";
  };

  # 定义用户账户。不要忘记使用'passwd'设置密码.
  users.users.kopfhanger= {
    isNormalUser = true;
    description = "kopfhanger";
   extraGroups = [ "networkmanager" "wheel" "storage" "disk" "video" "audio" ];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  # GNOME 与 Niri 共存；GDM 会在登录界面提供两个 Wayland 会话。
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;
  services.displayManager.defaultSession = "niri";

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    APPIMAGE_EXTRACT_AND_RUN = "1";
   GDK_BACKEND = "wayland,x11";
   QT_QPA_PLATFORM = "wayland;xcb";
   SDL_VIDEODRIVER = "wayland";
   CLUTTER_BACKEND = "wayland";
  };

  # 允许非自由软件
  nixpkgs.config.allowUnfree = true;

  # 在系统文件中列出要安装的软件. 要搜索，运行:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # 不要忘了安装编辑器以编辑 configuration.nix! 已经默认安装了 nano.
    os-prober
    efibootmgr
    grub2
    # 系统级工具
    p7zip
    fastfetch
    btop
    fzf
    fd
    bat
    ripgrep
    jq
    udisks2
    fishPlugins.tide
    fishPlugins.fzf-fish
    fishPlugins.pisces
    fishPlugins.forgit
    fishPlugins.done
    fishPlugins.bass
    fishPlugins.pure
    adw-gtk3
    adwaita-qt
    xwayland-satellite
    onedrive
    wineWow64Packages.waylandFull
    winetricks
    grim
    slurp
    wl-clipboard-rs
    wget
  ];

  # 设置 vscode 的 wayland 环境变量
  # Wayland 环境变量已统一到 users.users.kopfhanger.extraGroups 后

  # 自动系统更新
  system.autoUpgrade = {
    enable = true;
    flake = "/etc/nixos";
    flags = [ "--update-input" "nixpkgs" ];
    allowReboot = false;
  };

  # Nix 垃圾回收和优化
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nix.settings = {
    auto-optimise-store = true;
    keep-outputs = true;
    keep-derivations = true;
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store?priority=10"
      "https://cache.nixos.org/"
    ];
    experimental-features = [ "nix-command" "flakes" ];

    # noctalia 是 C++/Qt(meson+ninja) 项目，编译峰值内存很高。之前 max-jobs=16
    # （=16 线程全开）配 0 swap，内核 OOM killer 连着把 foot 终端 scope 里的进程
    # 杀掉，表现就是"编译时终端闪退"。这里限制并发编译进程数（≈max-jobs×cores）：
    # 想更快可以把 cores 提到 4，想更稳就降到 1。
    max-jobs = 4;
    cores = 2;
  };

  # 编译峰值内存保护：zram 用压缩内存当快速 swap，再加一个磁盘 swapfile 兜底。
  # btrfs 上由 nixpkgs 自动改用 `btrfs filesystem mkswapfile` 生成 nocow swapfile，
  # 并按文件大小判断是否已存在（幂等，不会每次开机重建）。
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # MiB = 16 GiB
    }
  ];

  # 一些程序需要 SUID 包装器，可以进一步配置或在用户会话中启动。
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.appimage = {
   enable = true;
   binfmt = true;
  };
  programs.dsh.enable = true;

  security.polkit.enable = true;
  security.soteria.enable = true;

  # 列出您要启用的服务：
  services.dbus.enable = true;
  # 26.05 起默认实现已切换为 Broker，这里显式声明以固定系统行为。
  services.dbus.implementation = "broker";
  services.udisks2.enable = true;
  services.v2raya.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.blueman.enable = true;
  # services.onedrive.enable = true;

  # 启用 OpenSSH 守护进程.
  # services.openssh.enable = true;

  services.xserver.enable = true;
  # 使用 Pipewire 启用声音。
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # 如果您想使用 JACK 应用，取消此行注释
    #jack.enable = true;
  };

  # 防火墙端口设置.
  networking.firewall.enable = true;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # 或者完全禁用防火墙.
  # networking.firewall.enable = false;

  # 该主机按 NixOS 26.11pre 的状态默认值维护；Home Manager 的状态版本单独为 26.05。
  system.stateVersion = "26.11";

}
