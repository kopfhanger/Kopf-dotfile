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
    url = "git+https://gh.dpik.top/https://github.com/nix-community/home-manager.git?ref=release-26.05&shallow=1";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  nix-wpsoffice-cn = {
    url = "git+https://gh.dpik.top/https://github.com/Beriholic/nix-wpsoffice-cn.git?shallow=1";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};

  outputs = inputs@{ nixpkgs, zen-browser, home-manager, ... }:
  let
    system = "x86_64-linux";

  in
  {
   nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
     inherit system;

      specialArgs = { inherit inputs; };

      modules = [
        ./configuration.nix

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
