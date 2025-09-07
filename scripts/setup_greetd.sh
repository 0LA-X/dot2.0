#!/bin/bash

# Install required packages
echo "Installing greetd and tuigreet..."
yay -S --noconfirm greetd greetd-tuigreet-git

# Create greetd directory if it doesn't exist
echo "Creating /etc/greetd directory..."
sudo mkdir -p /etc/greetd

# Create config.toml
echo "Creating /etc/greetd/config.toml..."
sudo tee /etc/greetd/config.toml > /dev/null << 'EOF'
[terminal]
# This should be the TTY you want greetd to run on, typically tty1
vt = 1

[default_session]
command = "tuigreet --greeting 'Arch Linux' --time --remember --remember-user-session --user-menu --sessions /usr/share/wayland-sessions --session-wrapper /etc/greetd/launch-session.sh"
user = "greeter"
EOF

# Create launch-session.sh
echo "Creating /etc/greetd/launch-session.sh..."
sudo tee /etc/greetd/launch-session.sh > /dev/null << 'EOF'
#!/bin/bash

# Source user profile
[ -f ~/.bash_profile ] && source ~/.bash_profile

# Execute session (Wayland only here)
exec dbus-run-session -- "$@"
EOF

# Make launch-session.sh executable
echo "Making launch-session.sh executable..."
sudo chmod +x /etc/greetd/launch-session.sh

# Create greeter user
echo "Creating greeter user..."
sudo useradd -M -N -s /usr/bin/nologin greeter

# Enable greetd service
echo "Enabling greetd service..."
sudo systemctl enable greetd

echo "Setup complete! Please reboot to start using greetd."
