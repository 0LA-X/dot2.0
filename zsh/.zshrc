# Launch TMUX on terminal startup
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux attach-session -t main || tmux new-session -s main
fi

pokego --name eevee -no-title -s

export ZSH="$HOME/.oh-my-zsh"

# Plugin list (standard and custom)
plugins=(
  git
  sudo
  zsh-autosuggestions
  zsh-interactive-cd
)

# Load custom completions
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
autoload -U compinit && compinit

# Load Oh My Zsh
source "$ZSH/oh-my-zsh.sh"

export PATH="$PATH:/usr/bin"
export PATH="$HOME/.cargo/bin:$PATH"

export TERMINAL=ghostty
export EDITOR=nvim
export SYSTEMD_EDITOR=nvim

# [ Aliases & Shortcuts ] 
# -- Navigation
alias .='z ../'
alias ..='z ../../'
alias ...='z ../../../'
alias ....='z ../../../../'

# -- File listing (eza)
alias c='clear'
alias x='exit'
alias l='eza -lh --icons=auto'
alias ls='eza -G --icons=auto'
alias lsa='eza -Ga --icons=auto'
alias ll='eza -lha --icons=auto --sort=name --group-directories-first'
alias ld='eza -lhD --icons=auto'
alias lt='eza --icons=auto --tree'

alias vi='nvim'
alias vim='sudo nvim'
alias sudo-nvim='sudo env WAYLAND_DISPLAY=$WAYLAND_DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR HOME=/root nvim'

alias pacman='sudo pacman'

alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'

alias gparted='sudo -E gparted'

alias yt-720='yt-dlp -f "bestvideo[height=720]+bestaudio/best[height=720]"'
# -- Apps
alias obsidian='obsidian --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland --ozone-platform-hint=auto'

# -- User session management
alias exit-user='pkill quickshell || pkill caelstia || pkill Hyprland || pkill tmux || loginctl terminate-user $USER'
alias exit-user_alt='pkill -TERM -u $USER'

eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"

# [ Zsh History Options ]
HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups

eval "$(starship init zsh)"

# Load zsh-syntax-highlighting LAST
source "${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
