set fish_greeting ""

set -gx TERM xterm-256color

# theme

set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

# colors

# 005fd7
set -g fish_color_command ffffff --bold
# 00afff
set -g fish_color_param cccccc
# cyan
set -g fish_color_escape ffffff --bold
set -g fish_color_operator ffffff --bold

alias ll "eza -l -g --icons"
alias lla "ll -a"
alias bb "bat -P -p"