<img width="50%" alt="Screenshot - Terminal and Browser" src="https://github.com/user-attachments/assets/ee42d653-6ac6-4fda-b66e-fb0bcf81b46b" /><img width="50%" alt="Screenshot - VSCode and FreeCAD" src="https://github.com/user-attachments/assets/a9e04e63-56ac-4d23-8ba9-d1513722058c" />

# Ansible for Fedora Workstation

Configure and manage [Fedora](https://fedoraproject.org/) Workstation 43 using [Ansible](https://github.com/ansible/ansible). Fedora Workstation is a polished, easy to use operating system for laptop and desktop computers, with a complete set of tools for developers and makers of all kinds. Ansible is a suite of software tools that enables infrastructure as code.

This repository contains IaC that automates the post-installation tasks for Intel/AMD x86-64 desktop and laptop computers using Fedora Workstation 43. Tasks include the installation of RPM and Flatpak packages needed for system administration, development, and engineering.

- [Ansible for Fedora Workstation](#ansible-for-fedora-workstation)
  * [One-Liner Install (Recommended)](#one-liner-install-recommended)
    + [Quick Start](#quick-start)
  * [Using This Repo](#using-this-repo)
  * [Keyboard Shortcuts](#keyboard-shortcuts)
    + [Modifier Keys](#modifier-keys)
    + [Workspace Management](#workspace-management)
    + [Application Launchers](#application-launchers)
    + [Favorites Bar (Dock)](#favorites-bar-dock)
  * [Prerequisites](#prerequisites)
  * [Preparations](#preparations)
    + [Download ISO image directly (optional)](#download-iso-image-directly-optional)
    + [OS and Ansible Installation](#os-and-ansible-installation)
  * [Usage](#usage)
    + [Basic Commands](#basic-commands)
    + [Running Playbook](#running-playbook)
  * [Task Breakdown](#task-breakdown)
    + [Pre-tasks: Environment Validation](#pre-tasks-environment-validation)
    + [`tasks/capture.yml` - User Context Detection](#taskscaptureyml---user-context-detection)
    + [`tasks/update.yml` - System Update](#tasksupdateyml---system-update)
    + [`tasks/packages.yml` - Core RPM Packages](#taskspackagesyml---core-rpm-packages)
    + [`tasks/rpmfusion.yml` - RPM Fusion Repositories](#tasksrpmfusionyml---rpm-fusion-repositories)
    + [`tasks/flatpak.yml` - Flatpak & Flathub Applications](#tasksflatpakyml---flatpak--flathub-applications)
    + [`tasks/cargo.yml` - Rust (Cargo) Packages](#taskscargoyml---rust-cargo-packages)
    + [`tasks/security.yml` - SELinux Configuration](#taskssecurityyml---selinux-configuration)
    + [`tasks/gnome.yml` - GNOME Desktop Customization](#tasksgnomeyml---gnome-desktop-customization)
    + [`tasks/fonts.yml` - User Font Installation](#tasksfontsyml---user-font-installation)
    + [`tasks/dotfiles.yml` - Dotfile Management (chezmoi)](#tasksdotfilesyml---dotfile-management-chezmoi)
    + [`tasks/git.yml` - Git & SSH Configuration](#tasksgityml---git-and-ssh-configuration)
    + [`tasks/shell.yml` - Shell Configuration](#tasksshellyml---shell-configuration)
    + [`tasks/firefox.yml` - Firefox Policy Management](#tasksfirefoxyml---firefox-policy-management)
    * [`tasks/vscode.yml` - VS Code Extensions & Themes](#tasksvscodeyml---vs-code-extensions--themes)
  * [Configuration Variables](#configuration-variables)
  * [Additional Resources](#additional-resources)
  * [License](#license)

## One-Liner Install (Recommended)

This repository supports a **single-command bootstrap** that installs Ansible (if missing), clones the repository, and runs the playbook on your local Fedora Workstation.

### Quick Start

Run this command on a **fresh Fedora Workstation 43 install**:

```bash
curl -fsSL https://raw.githubusercontent.com/kayleefedorick/ansible-for-fedora-workstation/main/install.sh | bash
```

## Using This Repo

This repository is intentionally opinionated. It reflects how I want a Fedora Workstation system to behave out of the box. It provides a reproducible baseline that I can apply to a fresh system and immediately be productive.

Some of the behavior pre-configured here relies on my dotfiles repository:

**[https://github.com/kayleefedorick/dotfiles](https://github.com/kayleefedorick/dotfiles)**

You have three paths:

1. **Use it as-is**: 
   Clone the repo, apply the playbooks, and also use my dotfiles for the intended experience.

2. **Use it as a base**: 
   Fork it, remove or replace opinionated pieces, and layer in your own dotfiles and workflows.

3. **Start from scratch**: 
   Treat this repo as a reference for structured workstation provisioning with Ansible.

<img width="100%" alt="Screenshot - GNOME Desktop" src="https://github.com/user-attachments/assets/ed8cb75c-bc1a-47bc-9958-740292da1635" />

## Keyboard Shortcuts

### Modifier Keys

* **Super** = ⊞ Command / Windows Key

### Workspace Management

| Shortcut               | Action                                     |
| ---------------------- | ------------------------------------------ |
| `Super + 1..4`         | Switch to workspace 1–4                    |
| `Shift + Super + 1..4` | Move active window to workspace 1–4        |
| `Super + ← ↑ → ↓`      | Move active window to a tile               |
| `Super + Q`            | Close active window                        |

### Application Launchers

| Shortcut         | Action                                           |
| ---------------- | ------------------------------------------------ |
| `Super + Return` | Launch **Alacritty** (Terminal)                  |
| `Super + E`      | Launch **Alacritty** running **micro** (Editor)  |
| `Super + B`      | Launch **Firefox** (Browser)                     |
| `Super + F`      | Open **Files**                                   |
| `Super + /`      | Launch **Bitwarden** (Password manager)          |
| `Super + .`      | Launch **Qalculate** (Advanced calculator)       |

### Favorites Bar (Dock)

| Shortcut    | Application        |
| ----------- | ------------------ |
| `Super + 5` | Thunderbird        |
| `Super + 6` | Spotify            |
| `Super + 7` | Visual Studio Code |
| `Super + 8` | FreeCAD            |
| `Super + 9` | KiCad              |

## Prerequisites

- Fedora Workstation 43 (x86-64)
- Ansible (core) >= 2.18.9

## Preparations

There are multiple ways to obtain Fedora installation media:

- Use Fedora Media Writer, the official, tested and supported way to make bootable media. See [Download options](https://fedoraproject.org/workstation/download)
- Download the [ISO image using BitTorrent](https://torrent.fedoraproject.org/torrents/Fedora-Workstation-Live-x86_64-43.torrent)
- Download the [ISO image directly](https://download.fedoraproject.org/pub/fedora/linux/releases/43/Workstation/x86_64/iso/Fedora-Workstation-Live-43-1.6.x86_64.iso)

### Download ISO image directly (optional)

In case you decide to download the ISO image directly, check the integrity of file.

Run:

```bash
sha256sum Fedora-Workstation-Live-43-1.6.x86_64.iso
```

Ensure the output value:

```bash
2a4a16c009244eb5ab2198700eb04103793b62407e8596f30a3e0cc8ac294d77
```

### OS and Ansible Installation

Obtain and install Fedora using one of the options above. After you have finished a fresh installation of Fedora Workstation 43, login and install Ansible:

```bash
sudo dnf install -y ansible
```

Clone the repository and enter it:

```bash
git clone https://github.com/kayleefedorick/ansible-for-fedora-workstation.git && cd ansible-for-fedora-workstation
```

## Usage

### Basic Commands

Check syntax:
```bash
ansible-playbook playbook.yml --syntax-check
```

List all tasks:
```bash
ansible-playbook playbook.yml --list-tasks
```

List target hosts:
```bash
ansible-playbook playbook.yml --list-hosts
```

Dry run (show changes without applying):
```bash
ansible-playbook playbook.yml --check --diff
```

### Running Playbook

Run the playbook on localhost:
```bash
ansible-playbook playbook.yml --ask-become-pass
```
## Task Breakdown

### Pre-tasks: Environment Validation

**Check Fedora Version**

* Ensures the playbook is running on Fedora Workstation 43
* Fails fast if the distribution or version does not match
* Prevents accidental execution on unsupported systems

### `tasks/capture.yml` - User Context Detection

* Captures the *actual invoking user* (even when running with `sudo`)
* Sets the `current_user` fact
* Used later for:

  * Font installation
  * Dotfiles
  * User shell configuration

### `tasks/update.yml` - System Update

* Updates all installed RPM packages to their latest versions
* Ensures the system is fully up to date before additional software is installed

### `tasks/packages.yml` - Core RPM Packages

Installs RPM packages grouped by purpose:

* **System packages**

  * Core administration and utility tools
  * Virtualization group
* **Development packages**

  * Compilers, build tools, Python, Rust, Git, and engineering software
* **Desktop packages**

  * Terminal and system information utilities

All package lists are configurable via `vars/main.yml`.

### `tasks/rpmfusion.yml` - RPM Fusion Repositories

* Imports RPM Fusion Free and Nonfree GPG keys
* Enables RPM Fusion repositories matching the Fedora version
* Installs multimedia and hardware-accelerated packages not available in Fedora proper

This enables full codec support and enhanced graphics drivers.

### `tasks/flatpak.yml` - Flatpak & Flathub Applications

* Ensures Flatpak is installed
* Adds the Flathub remote if missing
* Installs desktop applications such as:

  * Bitwarden
  * Spotify
  * Visual Studio Code
  * Firefox, Thunderbird, VLC, GIMP, FreeCAD, KiCad

Flatpak applications are installed system-wide from Flathub.

### `tasks/cargo.yml` - Rust (Cargo) Packages

* Installs user-level Rust tools via `cargo`
* Runs without privilege escalation
* Example tools include modern CLI replacements (e.g. `eza`)

### `tasks/security.yml` - SELinux Configuration

* Ensures SELinux-related packages are installed
* Forces SELinux enforcing mode in `/etc/selinux/config`
* Enables enforcing mode at runtime if not already active

This provides baseline system security hardening.

### `tasks/gnome.yml` - GNOME Desktop Customization

Configures the GNOME desktop environment:

* Installs `gnome-extensions-cli` using `pipx`
* Installs and enables selected GNOME Shell extensions
* Applies extensive GNOME settings via `dconf`, including:

  * Dark mode and accent color
  * Night Light
  * Wallpaper configuration
  * Dock favorites
  * Custom keyboard shortcuts
  * Workspace and window management keybindings

#### GNOME Files Sidebar Folders

Manages custom folders in the GNOME Files (Nautilus) sidebar:

* Creates user directories in the home folder based on a configurable list
* Ensures the GTK bookmarks configuration directory exists
* Adds each folder to the GNOME Files sidebar using GTK bookmarks
* Avoids duplicate sidebar entries

This feature uses GNOME’s native GTK bookmark mechanism rather than filesystem symlinks.

### `tasks/fonts.yml` - User Font Installation

* Downloads Nerd Fonts archives
* Extracts and installs missing `.otf` fonts into the user’s local font directory
* Avoids reinstalling fonts that already exist
* Refreshes the font cache
* Optional cleanup of temporary files (disabled by default)

Fonts are installed **per-user**, not system-wide.

### `tasks/dotfiles.yml` - Dotfile Management (chezmoi)

* Detects whether `chezmoi` is initialized
* Initializes dotfiles from the configured GitHub repository if needed
* Fetches upstream changes
* Updates dotfiles only when the local copy is behind

This ensures dotfiles stay in sync without unnecessary changes.

### `tasks/git.yml` - Git and SSH Configuration

Configures Git and SSH for the invoking user:

* Ensures required packages are installed:
  * `git`
  * `openssh`
* Creates the user’s `~/.ssh` directory with secure permissions
* Generates an SSH key pair only if one does not already exist
  * Uses `ed25519` by default
  * Avoids overwriting or reading existing (possibly passphrase-protected) keys
* Ensures correct permissions on the public key
* Configures global Git settings for the user:
  * `user.name`
  * `user.email`
  * `core.editor`
  * `init.defaultBranch`

### `tasks/shell.yml` - Shell Configuration

* Sets the **root shell** (default: `bash`)
* Sets the **user shell** (default: `zsh`)
* Uses captured user context to avoid misconfiguration

Shells are configurable through variables.

### `tasks/firefox.yml` - Firefox Policy Management

Manages Firefox flatpak policies using Mozilla’s `policies.json` mechanism:

* Ensures the Firefox policies directory exists
* Deploys a generated `policies.json` file with:
  * Locked Firefox preferences defined in `firefox_preferences`
  * Forced installation of extensions defined in `firefox_extensions`
  * Default allowance for other extensions unless explicitly overridden
* Terminates running Firefox instances to immediately apply changes if policies have changed

### `tasks/vscode.yml` - VS Code Extensions & Themes

* Ensures a VSIX directory exists for downloading extensions and themes
* Checks for existing VSIX files and only downloads missing ones
* Retrieves the list of installed VS Code extensions from the Flatpak instance
* Installs only missing extensions and themes from VSIX files
* Compatible with Flatpak-installed VS Code

## Configuration Variables

All user-configurable values live in:

```
vars/main.yml
```

Key variable groups, types, and descriptions:

| Variable                     | Type              | Description                                                                                                     |
| ---------------------------- | ----------------- | --------------------------------------------------------------------------------------------------------------- |
| `username`                   | `string`          | The main system username (usually the invoking user).                                                           |
| `github_username`            | `string`          | GitHub username for fetching dotfiles via chezmoi.                                                              |
| `git_user_home`              | `string`          | Home directory of the user (used for Git config and SSH keys).                                                  |
| `git_name`                   | `string`          | Git `user.name` value written to the global Git config.                                                         |
| `git_email`                  | `string`          | Git `user.email` value and default SSH key comment.                                                             |
| `git_editor`                 | `string`          | Default Git editor (`core.editor`).                                                                             |
| `git_default_branch`         | `string`          | Default branch name for new repositories (`init.defaultBranch`).                                                |
| `ssh_key_type`               | `string`          | SSH key type to generate (default: `ed25519`).                                                                  |
| `ssh_key_bits`               | `integer`         | Key size (used for RSA; ignored for `ed25519`, kept for compatibility).                                         |
| `ssh_key_comment`            | `string`          | Comment added to the SSH public key (defaults to `git_email`).                                                  |
| `ssh_key_path`               | `string`          | Full path to the SSH private key.                                                                               |
| `ssh_key_mode`               | `string`          | File mode applied to the SSH private key (default: `0600`).                                                     |
| `user_shell`                 | `string`          | Shell to set for the regular user (e.g., `"zsh"`).                                                              |
| `root_shell`                 | `string`          | Shell to set for root (e.g., `"bash"`).                                                                         |
| `firefox_flatpak_id`         | `string`          | Flatpak application ID for Firefox (used to detect and terminate running instances).                            |
| `firefox_flatpak_base_path`  | `string`          | Base filesystem path of the Firefox Flatpak installation.                                                       |
| `firefox_policies_dir`       | `string`          | Directory where Firefox `policies.json` is stored.                                                              |
| `firefox_policies_file`      | `string`          | Full path to the generated Firefox `policies.json` file.                                                        |
| `firefox_preferences`        | `dict`            | Map of Firefox preference keys to values. Each preference is written as locked via policies.                    |
| `firefox_extensions`         | `dict`            | Map of Firefox extension IDs to extension metadata (e.g., `install_url`) for force installation.                |
| `firefox_kill_running`       | `boolean`         | Whether to terminate running Firefox instances to immediately apply updated policies (`true` / `false`).        |
| `vscode_flatpak_id`          | `string`          | Flatpak application ID for Visual Studio Code (e.g., `"com.visualstudio.code"`).                                |
| `vscode_flatpak_cmd`         | `string`          | Flatpak run command for VS Code (usually the same as `vscode_flatpak_id`).                                      |
| `vscode_vsix_dir`            | `string`          | Directory to store downloaded VSIX files for extensions and themes.                                             |
| `vscode_extensions`          | `list of strings` | List of VS Code extensions to install via VSIX.                                                                 |
| `vscode_themes`              | `list of strings` | List of VS Code themes to install via VSIX.                                                                     |
| `system_packages`            | `list of strings` | List of RPM packages/groups for general system administration.                                                  |
| `development_packages`       | `list of strings` | List of development tools, compilers, and programming languages.                                                |
| `desktop_packages`           | `list of strings` | Desktop utilities and aesthetic tools.                                                                          |
| `rpmfusion_packages`         | `list of strings` | RPM Fusion-specific packages for multimedia and hardware support.                                               |
| `flatpak_packages`           | `list of strings` | Flatpak applications to install from Flathub.                                                                   |
| `cargo_packages`             | `list of strings` | Rust tools to install via Cargo.                                                                                |
| `gnome_extensions`           | `list of strings` | GNOME Shell extension identifiers to install and enable.                                                        |
| `gnome_settings`             | `list of dicts`   | GNOME settings to apply. Each dict requires:<br>`key: string` – DConf path<br>`value: string` – Setting value   |
| `gnome_sidebar_extras`       | `list of strings` | List of directory names to create in the user’s home directory and pin to the GNOME Files sidebar.              |
| `font_urls`                  | `list of strings` | URLs to font archives to download and install.                                                                  |
| `font_temp_dir`              | `string`          | Temporary directory for font downloads and extraction.                                                          |
| `cleanup_fonts`              | `boolean`         | Whether to remove the temporary font directory after installation (`true` / `false`).                           |

## Additional Resources

- [Ansible Community Documentation](https://docs.ansible.com/)
- [Awesome Ansible](https://github.com/ansible-community/awesome-ansible/blob/main/README.md)
- [Fedora Docs](https://docs.fedoraproject.org/)

## License

This project is licensed under GPL-3.0-or-later - see the [LICENSE](LICENSE) file for details.
