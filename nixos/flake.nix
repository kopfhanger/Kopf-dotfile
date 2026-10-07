{
  description = "NixOS 26.11pre 配置：GDM、GNOME、Niri 与 Noctalia v5";

inputs = {
  # 如果 nixpkgs 也慢，可换成清华/南大镜像：
  # nixpkgs.url = "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixos-unstable/nixexprs.tar.xz";
  # nixpkgs.url = "https://mirror.nju.edu.cn/nix-channels/nixos-unstable/nixexprs.tar.xz";
  nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";

  noctalia = {
    url = "git+https://gh.dpik.top/https://github.com/noctalia-dev/noctalia.git?shallow=1";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  zen-browser = {
    url = "git+https://gh.dpik.top/https://github.com/youwen5/zen-browser-flake.git?shallow=1";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  nixos-grub-themes = {
    url = "git+https://gh.dpik.top/https://github.com/jeslie0/nixos-grub-themes.git?shallow=1";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  home-manager = {
    # master 已把弃用的 stdenv.isLinux/isDarwin 换成 stdenv.hostPlatform.*；
    # release-26.05 至今未修，会持续产生 evaluation warning。
    # 本机 nixpkgs 是 unstable(26.11pre)，用 master 才是正确配对。
    url = "git+https://gh.dpik.top/https://github.com/nix-community/home-manager.git?ref=master&shallow=1";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  nix-wpsoffice-cn = {
    url = "git+https://gh.dpik.top/https://github.com/Beriholic/nix-wpsoffice-cn.git?shallow=1";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  deepseek-harness.url = "git+https://gh.dpik.top/https://github.com/moraxyc/deepseek-harness.nix";

  # ChatGPT 桌面版的 Nix 打包。上游仓库始终跟随官方可变 URL `.../latest/`，
  # 因而只能装到最新版；这里只借用它的打包逻辑，版本在 modules/chatgpt.nix
  # 中固定为 26.903.71938。复用本仓库 nixpkgs，避免再拉一套闭包。
  #
  # 必须按 rev 钉死，不能跟 main：上游在 26.928 的提交里把内置 tectonic 的路径
  # 从 resources/plugins/openai-bundled/plugins/latex/bin/tectonic 改成了
  # resources/tectonic/tectonic，而 903 的 deb 用的是旧路径，跟 main 会让
  # package.nix 里的 rm 找不到文件、编译直接失败。
  # 下面的 rev 就是上游把 903 固定住的那次提交，其 package.nix 与 903 的结构匹配。
  nixos-chatgpt = {
    url = "git+https://gh.dpik.top/https://github.com/csoftware-arigpt/nixos-chatgpt.git?rev=aa0e882c29b3080f1ba72f12749f3ee472dc6901&shallow=1";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};

  outputs = inputs@{ nixpkgs, zen-browser, home-manager, deepseek-harness, ... }:
  let
    system = "x86_64-linux";

  in
  {
   nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
     inherit system;

      specialArgs = { inherit inputs; };

      modules = [
        ./configuration.nix

	deepseek-harness.nixosModules.default

        # Home Manager 配置
        home-manager.nixosModules.home-manager
        {
         home-manager.useGlobalPkgs = true;
         home-manager.useUserPackages = true;
         home-manager.sharedModules = [ inputs.noctalia.homeModules.default ];
         home-manager.users.kopfhanger = import ./home.nix;
         home-manager.extraSpecialArgs = inputs;
        }

        # 显式列出系统模块，避免新增文件被动态导入后产生未审查的系统变更。
        ./modules/chatgpt.nix
        ./modules/chinese.nix
        ./modules/niri.nix
        ./modules/nvidia.nix
        ./modules/programs.nix
        ./modules/virtualization.nix

        # Zen Browser 和中文字体
        ({ pkgs, ... }: {
          environment.systemPackages = with pkgs; [
           inputs.zen-browser.packages.${system}.default
            # inputs.nix-wpsoffice-cn.packages.${system}.wpsoffice-cn
          ];

          fonts.packages = with pkgs; [
           inputs.nix-wpsoffice-cn.packages.${system}.chinese-fonts
          ];
        })
      ];
    };
  };
}
