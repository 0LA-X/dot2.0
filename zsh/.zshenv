export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export HISTFILE="$ZDOTDIR/.zhistory"    # History filepath

export TERM='xterm-256color'
export TERMINAL="kitty"

export EDITOR="nvim"
export VISUAL="nvim"
export SYSTEMD_EDITOR="nvim"
export MANPAGER="nvim +Man!"

#[ Xcompose IG ¯\_(ツ)_/¯]
# export GTK_IM_MODULE=xim
export QT_IM_MODULE=xim
export XMODIFIERS=@im=none

#[ PATH ]
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/env_01/bin:$PATH"
CORN="$HOME/Videos/yt-dlp/._tmp/.corn"

