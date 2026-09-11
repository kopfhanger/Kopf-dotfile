# source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

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

# Created by `pipx` on 2025-12-21 06:21:35
# fish_add_path 会去重，且使用 $HOME 便于在其他主机复用配置。
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

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# if test -f /opt/miniconda3/bin/conda
#     eval /opt/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# else
#     if test -f "/opt/miniconda3/etc/fish/conf.d/conda.fish"
#         . "/opt/miniconda3/etc/fish/conf.d/conda.fish"
#     else
#         set -x PATH "/opt/miniconda3/bin" $PATH
#     end
# end
# <<< conda initialize <<<
