#!/usr/bin/bash

set -e

# Install TPM (Tmux Plugin Manager)
function install_tpm() {
    local TMUX_CONF="$HOME/.config/tmux/tmux.conf"
    local TPM_DIR="$HOME/.config/tmux/plugins/tpm"

    if [[ -f "$TMUX_CONF" ]]; then
        echo -e "${GREEN}${CHECK} Detected tmux.conf at $TMUX_CONF${NC}"

        if [[ ! -d "$TPM_DIR" ]]; then
            echo -e "${YELLOW}${ARROW} Installing TPM into $TPM_DIR...${NC}"
            git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
        else
            echo -e "${GREEN}${CHECK} TPM already installed at $TPM_DIR.${NC}"
        fi

        echo -e "${BLUE}${GEAR} Installing TPM plugins...${NC}"
        "$TPM_DIR/bin/install_plugins"
    else
        echo -e "${YELLOW}${INFO} No tmux.conf found in ~/.config/tmux — skipping TPM install.${NC}"
    fi
}

install_tpm
