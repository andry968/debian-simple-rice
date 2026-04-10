#!/bin/bash
set -e

# === COLORS ===
ORANGE="\e[38;5;214m"
BLUE="\e[38;5;39m"
RESET="\e[0m"

clear
echo -e "${ORANGE}================================${RESET}"
echo -e "${ORANGE}     UNINSTALL DEBIAN RICE       ${RESET}"
echo -e "${BLUE}       By Andry Muh  (uninstall)   ${RESET}"
echo -e "${ORANGE}================================${RESET}\n"

# === CONFIRMATION ===
read -p "$(echo -e "${BLUE}This will remove ALL rice components, including all installed packages (except git and zsh), binaries, configs, and source folders.\nContinue? (y/n) ${RESET}")" confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo -e "${ORANGE}Uninstall cancelled.${RESET}"
    exit 1
fi

# === 1. REMOVE BINARIES INSTALLED SYSTEM-WIDE ===
echo -e "${BLUE}Removing Peaclock and Lavat binaries...${RESET}"
sudo rm -f /usr/local/bin/peaclock 2>/dev/null || true
sudo rm -f /usr/local/bin/lavat 2>/dev/null || true

# === 2. DELETE SOURCE DIRECTORIES ===
echo -e "${BLUE}Deleting source folders (~/cava, ~/peaclock, ~/lavat)...${RESET}"
rm -rf "$HOME/cava" "$HOME/peaclock" "$HOME/lavat" 2>/dev/null || true

# === 3. REMOVE CONFIGURATION DIRECTORIES ===
echo -e "${BLUE}Removing config directories...${RESET}"
rm -rf "$HOME/.config/cava" 2>/dev/null || true
rm -rf "$HOME/.config/fastfetch" 2>/dev/null || true
rm -rf "$HOME/.config/kitty" 2>/dev/null || true

# === 4. CLEAN SHELL RC FILES (.zshrc) ===
echo -e "${BLUE}Cleaning up ~/.zshrc...${RESET}"
if [ -f "$HOME/.zshrc" ]; then
    sed -i '/^fastfetch$/d' "$HOME/.zshrc"
    sed -i '/\/usr\/games/d' "$HOME/.zshrc"
    sed -i '/^alias cava=/d' "$HOME/.zshrc"
    sed -i '/^export LS_COLORS=/d' "$HOME/.zshrc"
    sed -i '/^alias ls=/d' "$HOME/.zshrc"
    sed -i '/^alias ll=/d' "$HOME/.zshrc"
    sed -i '/^alias grep=/d' "$HOME/.zshrc"
    sed -i '/^export LESS_TERMCAP/d' "$HOME/.zshrc"
    sed -i '/^# === COLOR SETUP ===/d' "$HOME/.zshrc"
    echo -e "${ORANGE}Cleaned up ~/.zshrc (PROMPT kept)${RESET}"
fi

# === 5. REMOVE ALL APT PACKAGES INSTALLED BY RICE SCRIPT (except git and zsh) ===
echo -e "${BLUE}Removing all packages installed by the rice script...${RESET}"
PACKAGES=(
    kitty kitty-terminfo fastfetch pipes-sh btop cmatrix
    cmake libicu-dev build-essential libfftw3-dev libasound2-dev
    libpulse-dev libtool automake libiniparser-dev libsdl2-2.0-0
    libsdl2-dev libpipewire-0.3-dev libjack-jackd2-dev pkgconf
    libncursesw5-dev
)
for pkg in "${PACKAGES[@]}"; do
    echo -e "${BLUE}Removing $pkg...${RESET}"
    sudo apt remove --purge -y "$pkg" 2>/dev/null || true
done
echo -e "${ORANGE}Note: git were NOT removed.${RESET}"

# === 6. AUTOREMOVE LEFTOVER DEPENDENCIES ===
echo -e "${BLUE}Cleaning up unused dependencies...${RESET}"
sudo apt autoremove --purge -y

# === 7. FINAL MESSAGE ===
echo -e "\n${BLUE}All rice components have been uninstalled.${RESET}"
echo -e "${ORANGE}Your GNOME interface settings, wallpaper, and Zsh shell remain untouched.${RESET}"
echo -e "${ORANGE}You may want to manually remove ~/Pictures/wallpaper.jpg if desired.${RESET}"
