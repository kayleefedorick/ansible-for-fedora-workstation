#!/usr/bin/env bash
set -euo pipefail

# Repo URLs
REPO_HTTPS_URL="https://github.com/kayleefedorick/ansible-for-fedora-workstation.git"
REPO_SSH_URL="git@github.com:kayleefedorick/ansible-for-fedora-workstation.git"

DEV_DIR="$HOME/Developer"
REPO_DIR="$DEV_DIR/ansible-for-fedora-workstation"
REQUIRED_FEDORA_VERSION="43"

echo "==> Ansible for Fedora Workstation bootstrap"

# Ensure Fedora
if [[ ! -f /etc/os-release ]]; then
  echo "ERROR: Cannot determine OS"
  exit 1
fi

. /etc/os-release

if [[ "$ID" != "fedora" ]]; then
  echo "ERROR: This script must be run on Fedora"
  exit 1
fi

if [[ "$VERSION_ID" != "$REQUIRED_FEDORA_VERSION" ]]; then
  echo "ERROR: Fedora $REQUIRED_FEDORA_VERSION is required (found $VERSION_ID)"
  exit 1
fi

echo "✔ Fedora $VERSION_ID detected"

# Ensure base dependencies
echo "==> Installing base dependencies"
sudo dnf install -y git curl ansible openssh xclip

# Prompt to set hostname
CURRENT_HOSTNAME="$(hostnamectl --static status 2>/dev/null || hostname)"

echo "==> Hostname configuration"
echo "Current hostname: $CURRENT_HOSTNAME"
read -rp "Enter a new hostname (or press Enter to keep current): " NEW_HOSTNAME

if [[ -n "$NEW_HOSTNAME" ]]; then
  echo "==> Setting hostname to '$NEW_HOSTNAME'"
  sudo hostnamectl set-hostname "$NEW_HOSTNAME"
  echo "✔ Hostname updated"
else
  echo "ℹ Keeping existing hostname"
fi
echo

# SSH key detection
SSH_KEY=""
for key in "$HOME/.ssh/id_ed25519" "$HOME/.ssh/id_rsa" "$HOME/.ssh/id_ecdsa"; do
  if [[ -f "$key" ]]; then
    SSH_KEY="$key"
    break
  fi
done

# Prompt to create SSH key if missing
if [[ -z "$SSH_KEY" ]]; then
  echo "ℹ No SSH key detected."
  read -rp "Would you like to generate an SSH key now? (recommended) [Y/n]: " reply
  reply="${reply:-Y}"

  if [[ "$reply" =~ ^[Yy]$ ]]; then
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"

    echo "==> Generating ed25519 SSH key"
    ssh-keygen -t ed25519 -f "$HOME/.ssh/id_ed25519" -C "$(whoami)@$(hostname)" -N ""

    SSH_KEY="$HOME/.ssh/id_ed25519"

    echo "==> Copying public key to clipboard"
    xclip -selection clipboard < "${SSH_KEY}.pub"

    echo
    echo "✔ SSH key generated!"
    echo "➡ Your public key has been copied to the clipboard."
    echo "➡ Add it to GitHub: https://github.com/settings/ssh/new"
    echo
  else
    echo "ℹ Skipping SSH key creation."
  fi
fi

# Decide which repo URL to use
SSH_KEY_FOUND=false
for key in "$HOME/.ssh/id_rsa" "$HOME/.ssh/id_ed25519" "$HOME/.ssh/id_ecdsa"; do
  [[ -f "$key" ]] && SSH_KEY_FOUND=true && break
done

if $SSH_KEY_FOUND; then
  echo "✔ SSH key detected, using SSH for GitHub"
  REPO_URL="$REPO_SSH_URL"
else
  echo "ℹ No SSH key detected, using HTTPS for GitHub"
  REPO_URL="$REPO_HTTPS_URL"
fi

# Clone or update repo
if [[ -d "$REPO_DIR/.git" ]]; then
  echo "==> Repository already exists, updating"
  git -C "$REPO_DIR" pull --rebase
else
  echo "==> Creating 'Developer' directory if it does not exist"
  mkdir -p "$DEV_DIR"

  echo "==> Cloning repository"
  git clone "$REPO_URL" "$REPO_DIR"
fi

cd "$REPO_DIR"

# Run playbook
echo "==> Running Ansible playbook"
ansible-playbook playbook.yml --ask-become-pass

echo "==> Done! System configuration complete."
echo "You should log out and log in again before using the system."
