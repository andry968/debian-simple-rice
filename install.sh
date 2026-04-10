#!/bin/bash

set -e

# === CLEAR TERMINAL AND SHOW TITLE ===
clear
ORANGE="\e[38;5;214m"
BLUE="\e[38;5;39m"
RESET="\e[0m"

echo -e "${ORANGE}==============================${RESET}"
echo -e "${ORANGE}       SIMPLE DEBIAN RICE     ${RESET}"
echo -e "${BLUE}       By Andry Muh.           ${RESET}"
echo -e "${ORANGE}==============================${RESET}\n"

# === CONFIRMATION ===
read -p "$(echo -e "${BLUE}Are you sure to download it? (y/n) ${RESET}")" confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo -e "${ORANGE}Cancelled by user.${RESET}"
    exit 1
fi

# === RETRY FUNCTION ===
git_clone_with_retry() {
    local repo_url="$1"
    local dir_name="$2"
    local max_attempts=3
    local attempt=1

    while [ $attempt -le $max_attempts ]; do
        echo -e "${BLUE}Cloning $dir_name (attempt $attempt/$max_attempts)...${RESET}"
        if git clone "$repo_url" "$dir_name"; then
            echo -e "${ORANGE}Successfully cloned $dir_name${RESET}"
            return 0
        fi
        echo -e "${ORANGE}Attempt $attempt failed. Retrying in 3 seconds...${RESET}"
        sleep 3
        ((attempt++))
    done

    echo -e "\e[31mFailed to clone $repo_url after $max_attempts attempts.${RESET}"
    echo -e "\e[31mCheck your internet connection and try again.${RESET}"
    return 1
}

# === UPDATE & INSTALLATION ===
echo -e "${BLUE}Updating package list...${RESET}"
sudo apt update

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

echo -e "${BLUE}Installing packages...${RESET}"
sudo apt install -y kitty fastfetch pipes-sh btop cmatrix git cmake libicu-dev \
    build-essential libfftw3-dev libasound2-dev libpulse-dev libtool automake \
    libiniparser-dev libsdl2-2.0-0 libsdl2-dev libpipewire-0.3-dev libjack-jackd2-dev \
    pkgconf libncursesw5-dev zsh

# === CAVA ===
echo -e "${BLUE}Building Cava from source...${RESET}"
cd "$HOME"
if [ ! -d "cava" ]; then
    git_clone_with_retry https://github.com/karlstav/cava.git cava || exit 1
else
    echo -e "${ORANGE}Cava directory already exists, pulling latest changes...${RESET}"
    cd cava && git pull && cd ..
fi
cd cava
./autogen.sh
./configure
make
echo -e "${ORANGE}Cava built successfully.${RESET}"

# === ZSH AS DEFAULT SHELL ===
if [[ "$SHELL" != "$(which zsh)" ]]; then
    echo -e "${BLUE}Changing default shell to Zsh...${RESET}"
    sudo chsh -s "$(which zsh)" "$USER"
    echo -e "${ORANGE}Shell changed. Please log out and back in for changes to take effect.${RESET}"
else
    echo -e "${ORANGE}Zsh is already the default shell.${RESET}"
fi

# === CONFIGURE SHELL RC FILES ===
echo -e "${BLUE}Configuring shell startup scripts...${RESET}"
touch "$HOME/.zshrc"

if ! grep -q 'PROMPT=' "$HOME/.zshrc" 2>/dev/null; then
    echo "PROMPT='%F{214}%n%f %F{39}%~%f $ '" >> "$HOME/.zshrc"
    echo -e "${ORANGE}Custom prompt added to ~/.zshrc${RESET}"
else
    echo -e "${ORANGE}PROMPT already exists in ~/.zshrc, skipped.${RESET}"
fi

if ! grep -q '/usr/games' "$HOME/.zshrc" 2>/dev/null; then
    echo 'export PATH="$PATH:/usr/games"' >> "$HOME/.zshrc"
    echo -e "${ORANGE}Added /usr/games to PATH in ~/.zshrc${RESET}"
else
    echo -e "${ORANGE}PATH /usr/games already exists in ~/.zshrc, skipped.${RESET}"
fi

if ! grep -q 'alias cava=' "$HOME/.zshrc" 2>/dev/null; then
    echo 'alias cava="~/cava/cava -p ~/.config/cava/config"' >> "$HOME/.zshrc"
    echo -e "${ORANGE}Cava alias added to ~/.zshrc${RESET}"
else
    echo -e "${ORANGE}Cava alias already exists in ~/.zshrc, skipped.${RESET}"
fi

if ! grep -q 'LS_COLORS' "$HOME/.zshrc" 2>/dev/null; then
    cat >> "$HOME/.zshrc" << 'EOF'

# === COLOR SETUP ===
export LS_COLORS="di=38;5;154:fi=0:ln=38;5;51:ex=38;5;196:*.sh=38;5;39:*.py=38;5;214:*.json=38;5;226:*.md=38;5;213:*.txt=38;5;255:*.png=38;5;200:*.jpg=38;5;200:*.zip=38;5;208:*.tar=38;5;208:*.gz=38;5;208"
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias grep='grep --color=auto'

export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;39m'
EOF

    echo -e "${ORANGE}Color setup added to ~/.zshrc${RESET}"
else
    echo -e "${ORANGE}LS_COLORS already exists in ~/.zshrc, skipped.${RESET}"
fi

if ! grep -q '^fastfetch$' "$HOME/.zshrc" 2>/dev/null; then
    echo 'fastfetch' >> "$HOME/.zshrc"
    echo -e "${ORANGE}Fastfetch added to ~/.zshrc (runs on terminal start)${RESET}"
else
    echo -e "${ORANGE}Fastfetch already in ~/.zshrc, skipped.${RESET}"
fi

# === CAVA CONFIG ===
echo -e "${BLUE}Setting up Cava config...${RESET}"
mkdir -p "$HOME/.config/cava"
if [ ! -f "$HOME/.config/cava/config" ]; then
    cp "$BASE_DIR/configsrc/cava/config" "$HOME/.config/cava/config"
    echo -e "${ORANGE}Cava config installed.${RESET}"
else
    echo -e "${ORANGE}Cava config already exists, skipped.${RESET}"
fi

# === FASTFETCH CONFIG ===
echo -e "${BLUE}Setting up Fastfetch config...${RESET}"
mkdir -p "$HOME/.config/fastfetch"
cp "$BASE_DIR/configsrc/fastfetch/debian.png" "$HOME/.config/fastfetch/debian.png"
if [ ! -f "$HOME/.config/fastfetch/config.jsonc" ]; then
    cp "$BASE_DIR/configsrc/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc"
    echo -e "${ORANGE}Fastfetch config installed.${RESET}"
else
    echo -e "${ORANGE}Fastfetch config already exists, skipped.${RESET}"
fi

# === KITTY CONFIG ===
echo -e "${BLUE}Setting up Kitty...${RESET}"
mkdir -p "$HOME/.config/kitty"
if [ ! -f "$HOME/.config/kitty/kitty.conf" ]; then
    cp "$BASE_DIR/configsrc/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
    echo -e "${ORANGE}Kitty config installed.${RESET}"
else
    echo -e "${ORANGE}Kitty config already exists, skipped.${RESET}"
fi

# === PEACLOCK ===
echo -e "${BLUE}Installing Peaclock...${RESET}"
cd "$HOME"
if [ ! -d "peaclock" ]; then
    git_clone_with_retry https://github.com/ksonney/peaclock.git peaclock || exit 1
fi
cd peaclock
./RUNME.sh build
sudo ./RUNME.sh install

# === LAVAT ===
echo -e "${BLUE}Installing Lavat...${RESET}"
cd "$HOME"
if [ ! -d "lavat" ]; then
    git_clone_with_retry https://github.com/AngelJumbo/lavat.git lavat || exit 1
fi
cd lavat
sudo make install

# === GNOME INTERFACE ===
echo -e "${BLUE}Setting up GNOME Interface...${RESET}"
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface accent-color 'orange'
gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'
gsettings set org.gnome.desktop.wm.preferences focus-mode 'mouse'

# === WALLPAPER ===
echo -e "${BLUE}Setting up Wallpaper...${RESET}"
mkdir -p "$HOME/Pictures"
WALL_SRC="$BASE_DIR/configsrc/walpaper/walpaper.jpg"
WALL_DEST="$HOME/Pictures/wallpaper.jpg"
cp "$WALL_SRC" "$WALL_DEST"

WALL_URI="file://$WALL_DEST"
gsettings set org.gnome.desktop.background picture-uri "$WALL_URI"
gsettings set org.gnome.desktop.background picture-uri-dark "$WALL_URI"
gsettings set org.gnome.desktop.background picture-options 'zoom'
gsettings set org.gnome.desktop.screensaver picture-uri "$WALL_URI"

echo -e "${ORANGE}Wallpaper installed and applied.${RESET}"
echo -e "${BLUE}All done!${RESET}"
echo -e "${ORANGE}Please log out and log back in for the shell change to take effect.${RESET}"
