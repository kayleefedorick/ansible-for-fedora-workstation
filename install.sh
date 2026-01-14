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

# Ensure basic tools
echo "==> Installing base dependencies"
sudo dnf install -y git curl ansible

# Decide which repo URL to use
if [[ -d "$HOME/.ssh" ]] && ls "$HOME/.ssh"/id_{rsa,ed25519,ecdsa} &>/dev/null; then
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
