#!/usr/bin/env bash

set -e

TMUX_CONF="$HOME/.config/tmux/tmux.conf"
TPM_DIR="$HOME/.config/tmux/plugins/tpm"

# Install TPM (Tmux Plugin Manager)
install_tpm() {
  if [[ ! -d "$TPM_DIR" ]]; then
    echo -e "[ + ] Installing TPM into $TPM_DIR..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
  else
    echo -e "TPM already installed at $TPM_DIR."
  fi

  echo -e "[ + ] Installing TPM plugins..."
  "$TPM_DIR/bin/install_plugins"
}

# Check if tmux.conf exists & source it.
config_tmux(){
  if [[ -f "$TMUX_CONF" ]]; then
    echo -e "[ ! ] Detected tmux.conf at $TMUX_CONF"
    tmux source "$TMUX_CONF"
    echo -e "[ ! ] Sourced tmux config ....."
    install_tpm
  else
    echo -e "[ ? ] No tmux.conf found in ~/.config/tmux ."
  fi
}


config_tmux
