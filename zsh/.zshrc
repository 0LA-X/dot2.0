# -------------------------------------
#   Launch TMUX on terminal startup
# -------------------------------------
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux attach-session -t NERD || tmux new-session -s NERD
fi

# -- Fun stuff
pokego -r 1,3,6 -no-title
# fastfetch

#  -- History
HISTSIZE=4000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history
HIST_STAMPS="dd/mm/yyyy"

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# -- -- -- -- -- -- -- --
# -- Completion system
# -- -- -- -- -- -- -- -- 
autoload -Uz compinit
compinit
_comp_options+=(globdots)

# Completion UI / highlighting
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'


#[ Keybindings (vi-safe) ] 
# -- Home / End
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[7~' beginning-of-line
bindkey '^[[8~' end-of-line

# -- Tab / Shift-Tab (forward / backward completion)
bindkey '^I' complete-word
bindkey '^[[Z' reverse-menu-complete
bindkey -M viins '^I' complete-word
bindkey -M viins '^[[Z' reverse-menu-complete

# -- Tools
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"

# -- -- -- -- -- -- -- -- -- -- -- -- 
#[ Zinit setup ]
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# -- Plugins
zinit ice depth=1; zinit light jeffreytse/zsh-vi-mode

zinit light z-shell/F-Sy-H

zinit light zsh-users/zsh-completions

# Autosuggestions -- lazy loaded
zinit light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#CBAACB" #[ == #BFFF00  #B7410E #B2FFFF #CBAACB ]

export STARSHIP_SHELL=zsh
export STARSHIP_DISABLE_VIRTUALENV_PROMPT=1
zinit ice as"command" from"gh-r" \
  atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
  atpull"%atclone" src"init.zsh"
zinit light starship/starship

# Syntax highlighting -- lazy loaded
zinit light zsh-users/zsh-syntax-highlighting

# Prevent starship <-> vi-mode recursion
zstyle ':zsh-vi-mode:*' prompt ''


#[ Aliases ]
# -- Navigation
alias .='z ../'
alias ..='z ../../'
alias ...='z ../../../'
alias ....='z ../../../../'

# Listing (eza)
alias c='clear'
alias x='exit'
alias l='eza -lh --icons=auto'
alias ls='eza -G --icons=auto'
alias lsa='eza -Ga --icons=auto'
alias ll='eza -lha --icons=auto --sort=name --group-directories-first'
alias ld='eza -lhD --icons=auto'
alias lt='eza --icons=auto --tree'

# Trash
alias tp='trash-put'

# Editor
alias vi='nvim'
alias vim='sudo nvim'
alias sudo-nvim='sudo env WAYLAND_DISPLAY=$WAYLAND_DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR HOME=/root nvim'
alias sudo-vi='sudo env WAYLAND_DISPLAY=$WAYLAND_DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR HOME=/root nvim'

# Git
alias ga='git add '
alias ga.='git add .'
alias gc='git commit -m'
alias gca='git commit --amend'
alias gp='git push'
alias gs='git status'
alias gss='git status -s'
alias gr='git restore'

# Wi-Fi
alias wifilist='nmcli device wifi list'
alias wifiscan='nmcli device wifi list --rescan yes'
alias wificonnect='nmcli device wifi connect --ask'

# System
alias pacman='sudo pacman'
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias gparted='sudo -E gparted'

# yt-dlp
alias yt-480='yt-dlp -f "bestvideo[height=480]+bestaudio/best[height=480]"'
alias yt-720='yt-dlp -f "bestvideo[height=720]+bestaudio/best[height=720]"'

# Session
alias exit-user='pkill -TERM -u $USER'
alias logout-user='pkill Hyprland || pkill tmux || loginctl terminate-user $USER'
