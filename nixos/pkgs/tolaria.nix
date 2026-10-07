# Tolaria：Markdown 知识库桌面应用（Tauri 2）。
#
# 官方只发布 AppImage / deb / rpm，没有 Nix 包，nixpkgs 里也没有。
# 这里把官方 AppImage 用 appimageTools 包成一个常规 Nix 包：带 bin/tolaria、
# desktop 文件、hicolor 图标，以及 x-scheme-handler/tolaria 深链注册。
#
# 升级步骤：把 version / tag 及两个 URL 里的版本改掉，然后
#   nix store prefetch-file --json <新 AppImage URL>
# 用返回的 hash 替换下面即可。
#
# 下载源注意：本机直连 GitHub Releases 只有 ~11 KB/s（94MB 要两小时），
# 所以 urls 第一位放镜像，失败时回退到 GitHub 官方地址（两者内容相同，hash 一致）。
{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "tolaria";
  version = "2026.9.24";
  tag = "v2026-09-24";

  src = fetchurl {
    name = "Tolaria_${version}_amd64.AppImage";
    urls = [
      "https://ghfast.top/https://github.com/refactoringhq/tolaria/releases/download/${tag}/Tolaria_${version}_amd64.AppImage"
      "https://github.com/refactoringhq/tolaria/releases/download/${tag}/Tolaria_${version}_amd64.AppImage"
    ];
    hash = "sha256-q8HpHgctRjoqeNTVagHuxt1RUMlwu5F0fRVmYbydrqU=";
  };

  # 单独解包一次，用来取 AppImage 内的 .desktop 与图标。
  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/Tolaria.desktop $out/share/applications/tolaria.desktop
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = {
    description = "Personal knowledge and life management app";
    homepage = "https://tolaria.md";
    license = lib.licenses.agpl3Plus;
    mainProgram = "tolaria";
    platforms = [ "x86_64-linux" ];
  };
}
