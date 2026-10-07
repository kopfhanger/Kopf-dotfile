# ChatGPT 桌面版，默认固定在 26.903.71938（903 系列最后一版）。
#
# 为什么需要单独固定版本：
#   上游 csoftware-arigpt/nixos-chatgpt 只打包官方这个地址
#     https://persistent.oaistatic.com/codex-app-prod/linux/deb/latest/chatgpt_amd64.deb
#   它是可变的“latest”，上游自动化每小时同步一次，所以仓库里永远是当前最新
#   （写作时是 26.908.70816）。而 26.908 在本机一启动就报错打不开，需要退回 903。
#
# 做法：
#   1. 复用上游 flake 的打包逻辑（package.nix：dpkg 解包、patchELF、
#      wrapGAppsHook、desktop 集成、以及对 app.asar / tectonic 的两个修补）；
#   2. 用 overrideAttrs 把 src 与 version 换成官方 APT pool 中带版本号的
#      不可变 URL —— pool 会保留旧版本，因此这个地址是长期稳定的。
#
# 回退到上游最新版：
#   把下面的 pin903 改成 false，然后 nixos-rebuild switch 即可
#   （那时装的就是上游当时的 latest，写作时为 26.908.70816）。
#
# 版本号与 hash 的来源（两者已交叉验证一致）：
#   - 上游把 903 固定住的那次提交 aa0e882c 的 sources.nix：
#       version = "26.903.71938";
#       hash    = "sha256-E/Rt9zsG324T6edQsvPImphYY3QeqCXS01b1JVn1Wr0=";
#   - 官方 APT 索引/文件实测：
#       sha256(chatgpt_26.903.71938_amd64.deb)
#         = 13f46df73b06df6e13e9e750b2f3c89a985863741ea825d2d356f52559f55abd
#         = sha256-E/Rt9zsG324T6edQsvPImphYY3QeqCXS01b1JVn1Wr0=
#
# 注意：上游 package.nix 在 903 与 908 之间没有任何改动，且上游 CI 已用同一份
# package.nix 成功构建并冒烟测试过 26.903.71938，所以这些修补对 903 是适用的。
{ pkgs, inputs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;

  # 上游的包：跟随官方可变 `latest`，写作时为 26.908.70816。
  upstream = inputs.nixos-chatgpt.packages.${system}.chatgpt;

  # true = 固定 903（默认）；改成 false 就回退上游最新版。
  pin903 = false;

  chatgpt =
    if pin903 then
      upstream.overrideAttrs (old: {
        version = "26.903.71938";
        name = "chatgpt-26.903.71938";
        src = pkgs.fetchurl {
          name = "chatgpt_26.903.71938_amd64.deb";
          url = "https://persistent.oaistatic.com/codex-app-prod/linux/deb/pool/main/c/chatgpt/chatgpt_26.903.71938_amd64.deb";
          hash = "sha256-E/Rt9zsG324T6edQsvPImphYY3QeqCXS01b1JVn1Wr0=";
        };
      })
    else
      upstream;
in
{
  environment.systemPackages = [ chatgpt ];
}
