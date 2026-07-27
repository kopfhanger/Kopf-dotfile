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
set PATH $PATH /home/kopfhanger/.local/bin

set -x PYTHONPATH /usr/local/lib/python3.14/site-packages $PYTHONPATH
set -x PYTHONPATH /usr/local/share/chrono/python $PYTHONPATH
set -x LD_LIBRARY_PATH /usr/local/lib $LD_LIBRARY_PATH

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
