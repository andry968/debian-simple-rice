# Simple Debian Rice

![Platform](https://img.shields.io/badge/Platform-Debian%20Based-red?style=flat-square&logo=debian)
![DE](https://img.shields.io/badge/DE-GNOME-blue?style=flat-square&logo=gnome)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)
![Shell](https://img.shields.io/badge/Shell-Bash-black?style=flat-square&logo=gnubash)

A simple and aesthetic configuration setup for Debian-based systems with GNOME desktop environment. Make your terminal and desktop look more alive without the complexity.

---

## Preview

<img width="1920" height="1080" alt="Screenshot From 2026-04-04 13-38-33" src="https://github.com/user-attachments/assets/0fcd0843-5587-418d-bc47-ef64b70c0605" />
<img width="1920" height="1080" alt="Screenshot From 2026-04-04 13-39-20" src="https://github.com/user-attachments/assets/ea6ff36b-0ac1-4b39-bb00-cf803cdbfadc" />
<img width="1920" height="1080" alt="Screenshot From 2026-04-04 13-38-49" src="https://github.com/user-attachments/assets/034a23f4-8ae5-495d-beb6-e627ef51638a" />

---

## Requirements

Before running the installer, make sure your system meets these requirements:

| Requirement | Detail |
|-------------|--------|
| Distro | Debian-based (Debian, Ubuntu, Mint, Pop!\_OS, Kali) |
| Desktop Environment | GNOME (use `install.sh`) or other DE (use `nongnomeinstall.sh`) |
| Storage | At least 600MB free |
| RAM (GNOME) | Minimum 4GB, recommended 12GB — GNOME uses around 2–4GB |
| RAM (other DE) | Around 1–3GB (XFCE, MATE, etc.) |

---

## Features

A curated set of terminal tools focused on aesthetics and a satisfying desktop experience:

| Tool | Description | Command |
|------|-------------|---------|
| `pipes` | Animated terminal screensaver | `pipes` |
| `cava` | Audio visualizer for terminal | `cava` |
| `cmatrix` | Matrix-style terminal animation | `cmatrix -C white` |
| `lavat` | Lava lamp-like terminal animation | `lavat` |
| `fastfetch` | System info display | `fastfetch` |
| `btop` | Modern resource monitor | `btop` |
| `peaclock` | Clean terminal clock | `peaclock` |

---

## Installation

Make sure your system is updated first:

```bash
sudo apt update && sudo apt upgrade -y
```

### GNOME Desktop Environment

```bash
git clone https://github.com/andry968/debian-simple-rice.git
cd debian-simple-rice
chmod +x install.sh
./install.sh
```

### Other Desktop Environment (XFCE, MATE, etc.)

```bash
git clone https://github.com/andry968/debian-simple-rice.git
cd debian-simple-rice
chmod +x nongnomeinstall.sh
./nongnomeinstall.sh
```

---

## Repository Structure

```
simple-debian-gnome-rice/
├── configsrc/
│   ├── cava/
│   │   └── config           # Cava audio visualizer config
│   ├── fastfetch/
│   │   ├── config.jsonc     # Fastfetch layout config
│   │   ├── debian.png       # Debian logo for fastfetch
│   │   └── NOTE.txt
│   ├── kitty/
│   │   └── kitty.conf       # Kitty terminal config
│   └── walpaper/
│       ├── walpaper.jpg     # Wallpaper
│       └── NOTE.txt
├── gnome-extension/
│   └── gnome-extension.md   # GNOME extension guide
├── install.sh               # Installer for GNOME
├── nongnomeinstall.sh       # Installer for other DE
├── uninstall.sh             # Uninstaller
├── LICENSE.md
└── README.md
```

---

## GNOME Extensions

GNOME extensions are not installed automatically. You need to install them manually.

See the guide here: [gnome-extension/gnome-extension.md](gnome-extension/gnome-extension.md)

---

## Uninstall

```bash
cd ~/debian-simple-rice
./uninstall.sh
cd ..
rm -rf simple-debian-gnome-rice
```

---

## Notes

- Tested on **Debian 13**
- Some tools may require additional dependencies depending on your setup
- Configs are stored in `configsrc/` and applied automatically by the installer
- If something breaks, feel free to open an issue

---

## FAQ

**Q: How do I move the Kitty terminal window?**

Kitty by default has no title bar, so you cannot drag it the usual way. To move it, hold `Super` (Windows key) then drag the window with your mouse anywhere on the screen.

---

**Q: How do I change the image displayed in Fastfetch?**

Open `configsrc/fastfetch/config.jsonc` and find the line that references the image path. Replace it with the path to your own image file. Make sure the image format is supported (PNG recommended). You can also drop your image into the `configsrc/fastfetch/` folder and update the path accordingly.

---

**Q: How do I switch back from Zsh to Bash?**

The installer sets Zsh as the default shell. If you want to revert back to Bash, run:

```bash
chsh -s /bin/bash
```

Then log out and log back in for the change to take effect. You can verify with:

```bash
echo $SHELL
```

It should return `/bin/bash`.

---

## Contributing

Feel free to use, modify, or improve this setup however you like. Contributions and suggestions are always welcome open a PR or issue anytime.

---

*Enjoy your rice 🍚 — Andry Muh*
