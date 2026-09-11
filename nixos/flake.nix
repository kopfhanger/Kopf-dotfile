{
  description = "NixOS 26.11pre 配置：GDM、GNOME、Niri 与 Noctalia v5";

  inputs = {
    # nixos-unstable 当前为 NixOS 26.11pre 开发线；官方 tarball 便于在受限网络中更新。
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";

    noctalia = {
      # v5 已迁移到独立仓库，不再依赖 quickshell/noctalia-shell。
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
     url = "github:youwen5/zen-browser-flake";
     inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-grub-themes = {
      url = "github:jeslie0/nixos-grub-themes";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      # Home Manager 的稳定发布线目前是 26.05；它可以与 NixOS 26.11pre 共存。
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-wpsoffice-cn = {
      url = "github:Beriholic/nix-wpsoffice-cn";
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
