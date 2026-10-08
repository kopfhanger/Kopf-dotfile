# CachyOS-specific user settings. NixOS manages its own Fish configuration.
if not string match --quiet --regex '^ID="?cachyos"?$' < /etc/os-release
    return
end

abbr -a b --function projectdo_build
abbr -a r --function projectdo_run
abbr -a t --function projectdo_test
abbr -a p --function projectdo_tool

set -gx GTK_IM_MODULE fcitx
set -gx QT_IM_MODULE fcitx
set -gx XMODIFIERS @im=fcitx
set -gx SDL_IM_MODULE fcitx
set -gx GLFW_IM_MODULE ibus  # 某些游戏可能需要这个

set -gx BROWSER zen-browser

# fish_add_path 会去重，使用 $HOME 便于复用。
fish_add_path --append --move "$HOME/.local/bin"

# 仅注入实际存在的本地 Python/动态库目录，避免污染所有 shell 会话。
for python_path in /usr/local/lib/python3.14/site-packages /usr/local/share/chrono/python
    if test -d "$python_path"; and not contains -- "$python_path" $PYTHONPATH
        set -a PYTHONPATH "$python_path"
    end
end
if test (count $PYTHONPATH) -gt 0
    set -gx PYTHONPATH $PYTHONPATH
end

if test -d /usr/local/lib; and not contains -- /usr/local/lib $LD_LIBRARY_PATH
    set -a LD_LIBRARY_PATH /usr/local/lib
end
if test (count $LD_LIBRARY_PATH) -gt 0
    set -gx LD_LIBRARY_PATH $LD_LIBRARY_PATH
end
