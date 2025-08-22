# Dotfiles

My personal dotfiles for **Hyprland + Waybar + Kitty + Zsh + Neovim (LazyVim)** on Arch Linux.

These configs aim for a **modern red/orange theme** with a clean workflow.

---

## 📦 Dependencies

### Core
- **git** – version control for managing this repo
- **stow** – for symlinking dotfiles into `~/.config` and `$HOME`

### Window Manager / Compositor
- **hyprland** – Wayland compositor
- **xdg-desktop-portal-hyprland** – portals for GTK apps
- **wl-clipboard** – copy/paste in Wayland
- **grim** + **slurp** – screenshots
- **swaybg** – wallpaper support (if not using Hyprpaper)
- **swaylock** (or **swaylock-effects**) – lock screen
- **swayidle** – idle management
- **waybar** – status bar

### Status Bar (Waybar) Extras
- **pavucontrol** – volume mixer
- **brightnessctl** – control screen brightness
- **nm-connection-editor** (and **NetworkManager**) – network management
- **blueman** (optional) – bluetooth applet
- **upower** – battery info
- **lm_sensors** – temperature sensors
- **playerctl** (optional) – media controls
- **jq** (optional) – validate JSON configs

### Terminal
- **kitty** – GPU-accelerated terminal
- **fastfetch** – system info fetcher (runs at Kitty startup)
- **zsh** – shell
- **oh-my-zsh** or **zinit** (optional) – plugin manager
- **powerlevel10k** – Zsh theme (see `.p10k.zsh`)

### Fonts
- **ttf-jetbrains-mono-nerd**
- **ttf-inter**
- (any other Nerd Fonts you like)

### Neovim (Editor)
- **neovim** (>= 0.9)
- **LazyVim** (plugin framework; included in repo)
- **ripgrep** – required for Telescope search
- **fd** – faster file finding
- **nodejs** + **npm** – for LSP servers (ts_ls, etc.)
- **go** – for `gopls`
- **python-pip** – for Python LSPs/tools
- **clang** (optional) – for C/C++ tooling
- **lua-language-server** – via Mason
- **bash-language-server** – via Mason
- **yaml-language-server** – via Mason
- **json-lsp** – via Mason
- **eslint_d** (optional) – for TypeScript linting/formatting

### Audio
- **pipewire**
- **pipewire-pulse**
- **wireplumber**
- **wpctl** – PipeWire CLI

### Other Utilities
- **acpid** – for Fn key handling (mute/volume events)
- **libnotify** (optional) – for notifications (`notify-send`)

---

## ⚡ Setup

Clone into `~/dotfiles` and stow:
```bash
git clone git@github.com:isaacwallace123/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow -v hypr kitty waybar zsh fastfetch nvim -t ~
