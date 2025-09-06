# Launch TMUX on terminal startup
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux attach-session -t main || tmux new-session -s main
fi

# fastfetch
pokego --name eevee -no-title -s # delcatty # eevee 

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Standard plugins can be found in $ZSH/plugins/
plugins=(
  git
  sudo
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-interactive-cd
)

# Custom plugins may be added to $ZSH_CUSTOM/plugins/

# -------------------------------------
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
autoload -U compinit && compinit
source "$ZSH/oh-my-zsh.sh"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

###################
## export $PATHS ##
###################
export PATH="$PATH:/usr/bin"  # If installed to /usr/bin
export TERMINAL="/usr/bin/kitty"  # e.g., "foot", "kitty", "alacritty"

# -----------------------
## [ Helpful aliases ] 
# -----------------------
alias c='clear' # clear terminal
alias x='exit' # Exit terminal
alias l='eza -lh --icons=auto' # long list
alias ls='eza -G --icons=auto' # short list
alias lsa='eza -Ga --icons=auto' # short list with hidden files
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto'                                       # long list dirs
alias lt='eza --icons=auto --tree' # list folder as tree

# Make navigation easier
alias .='z ../'
alias ..='z ../../'
alias ...='z ../../../'
alias ....='z ../../../../'

# [ User Management ]
alias exit-user='pkill -KILL -u $USER'
alias exit-user_alt='pkill -TERM -u $USER'

# [ QOL ]
alias vi='nvim'
alias sudo nvim='sudo env WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
    XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
    HOME=/root nvim'
alias sudo-nvim='sudo env WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
    XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
    HOME=/root nvim'
alias pacman='sudo pacman'

# [ Grub Command ]
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'

alias gparted='sudo -E gparted'

# yt-dlp
alias yt-720='yt-dlp -f "bestvideo[height=720]+bestaudio/best[height=720]"'
alias yt-480='yt-dlp -f "bestvideo[height=480]+bestaudio/best[height=480]"'

alias obsidian='obsidian --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland --ozone-platform-hint=auto'

# -------------------------

# Shell Intergration
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"

# -------------------------

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups

# -------------------------

eval "$(starship init zsh)"
