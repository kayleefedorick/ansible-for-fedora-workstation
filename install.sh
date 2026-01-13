#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/kayleefedorick/ansible-for-fedora-workstation.git"
REPO_DIR="$HOME/ansible-for-fedora-workstation"
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

# Clone or update repo
if [[ -d "$REPO_DIR/.git" ]]; then
  echo "==> Repository already exists, updating"
  git -C "$REPO_DIR" pull --rebase
else
  echo "==> Cloning repository"
  git clone "$REPO_URL" "$REPO_DIR"
fi

cd "$REPO_DIR"

# Run playbook
echo "==> Running Ansible playbook"
ansible-playbook playbook.yml --ask-become-pass

echo "==> Done! System configuration complete."
echo "You should log out and log in again before using the system."
