# Ansible for Fedora Workstation

Configure and manage [Fedora](https://fedoraproject.org/) Workstation 43 using [Ansible](https://github.com/ansible/ansible). Fedora Workstation is a polished, easy to use operating system for laptop and desktop computers, with a complete set of tools for developers and makers of all kinds. Ansible is a suite of software tools that enables infrastructure as code.

This repository contains IaC that automates the post-installation tasks for Intel/AMD x86-64 desktop and laptop computers using Fedora Workstation 43. Tasks include the installation of RPM and Flatpak packages needed for system administration, development, and engineering.

- [Ansible for Fedora Workstation](#ansible-for-fedora-workstation)
   * [Prerequisites](#prerequisites)
   * [Preparations](#preparations)
      + [Download ISO image directly (optional)](#download-iso-image-directly-optional)
      + [OS and Ansible Installation](#os-and-ansible-installation)
   * [Usage](#usage)
      + [Basic Commands](#basic-commands)
      + [Running Playbook](#running-playbook)
   * [Additional Resources](#additional-resources)
   * [License](#license)

## Prerequisites

- Fedora Workstation 43 (x86-64)
- Ansible (core) >= 2.18.9

## Preparations

There are alternative ways to obtain Fedora installation media:

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

---

## Playbook Execution Flow

The playbook executes tasks **sequentially** in the order they are imported in `playbook.yml`.
This order is intentional: early tasks establish system state and repositories, while later tasks configure user experience and shells.

High-level flow:

1. Environment validation (pre-tasks)
2. System capture and updates
3. Package and repository management
4. Developer tooling and desktop applications
5. Security hardening
6. Desktop (GNOME) customization
7. User environment configuration (fonts, dotfiles, shells)

---

## Task Breakdown

### Pre-tasks: Environment Validation

**Check Fedora Version**

* Ensures the playbook is running on **Fedora Workstation 43**
* Fails fast if the distribution or version does not match
* Prevents accidental execution on unsupported systems

---

### `tasks/capture.yml` - User Context Detection

* Captures the *actual invoking user* (even when running with `sudo`)
* Sets the `current_user` fact
* Used later for:

  * Font installation
  * Dotfiles
  * User shell configuration

---

### `tasks/update.yml` - System Update

* Updates **all installed RPM packages** to their latest versions
* Ensures the system is fully up to date before additional software is installed

---

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

---

### `tasks/rpmfusion.yml` - RPM Fusion Repositories

* Imports **RPM Fusion Free and Nonfree GPG keys**
* Enables RPM Fusion repositories matching the Fedora version
* Installs multimedia and hardware-accelerated packages not available in Fedora proper

This enables full codec support and enhanced graphics drivers.

---

### `tasks/flatpak.yml` - Flatpak & Flathub Applications

* Ensures Flatpak is installed
* Adds the **Flathub** remote if missing
* Installs desktop applications such as:

  * Bitwarden
  * Spotify
  * Visual Studio Code
  * Firefox, Thunderbird, VLC, GIMP, FreeCAD

Flatpak applications are installed system-wide from Flathub.

---

### `tasks/cargo.yml` - Rust (Cargo) Packages

* Installs user-level Rust tools via `cargo`
* Runs without privilege escalation
* Example tools include modern CLI replacements (e.g. `eza`)

---

### `tasks/security.yml` - SELinux Configuration

* Ensures SELinux-related packages are installed
* Forces **SELinux enforcing mode** in `/etc/selinux/config`
* Enables enforcing mode at runtime if not already active

This provides baseline system security hardening.

---

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

All extensions and settings are defined in `vars/main.yml`.

---

### `tasks/fonts.yml` - User Font Installation

* Downloads Nerd Fonts archives
* Extracts and installs missing `.otf` fonts into the user’s local font directory
* Avoids reinstalling fonts that already exist
* Refreshes the font cache
* Optional cleanup of temporary files (disabled by default)

Fonts are installed **per-user**, not system-wide.

---

### `tasks/dotfiles.yml` - Dotfile Management (chezmoi)

* Detects whether `chezmoi` is initialized
* Initializes dotfiles from the configured GitHub repository if needed
* Fetches upstream changes
* Updates dotfiles only when the local copy is behind

This ensures dotfiles stay in sync without unnecessary changes.

---

### `tasks/shell.yml` - Shell Configuration

* Sets the **root shell** (default: `bash`)
* Sets the **user shell** (default: `zsh`)
* Uses captured user context to avoid misconfiguration

Shells are configurable through variables.

---

## Configuration Variables

All user-configurable values live in:

```
vars/main.yml
```

Key variable groups, types, and descriptions:

| Variable               | Type              | Description                                                                                                   |
| ---------------------- | ----------------- | ------------------------------------------------------------------------------------------------------------- |
| `username`             | `string`          | The main system username (usually the invoking user).                                                         |
| `github_username`      | `string`          | GitHub username for fetching dotfiles via chezmoi.                                                            |
| `user_shell`           | `string`          | Shell to set for the regular user (e.g., `"zsh"`).                                                            |
| `root_shell`           | `string`          | Shell to set for root (e.g., `"bash"`).                                                                       |
| `system_packages`      | `list of strings` | List of RPM packages/groups for general system administration.                                                |
| `development_packages` | `list of strings` | List of development tools, compilers, and programming languages.                                              |
| `desktop_packages`     | `list of strings` | Desktop utilities and aesthetic tools.                                                                        |
| `rpmfusion_packages`   | `list of strings` | RPM Fusion-specific packages for multimedia and hardware support.                                             |
| `flatpak_packages`     | `list of strings` | Flatpak applications to install from Flathub.                                                                 |
| `cargo_packages`       | `list of strings` | Rust tools to install via Cargo.                                                                              |
| `gnome_extensions`     | `list of strings` | GNOME Shell extension identifiers to install and enable.                                                      |
| `gnome_settings`       | `list of dicts`   | GNOME settings to apply. Each dict requires:<br>`key: string` - DConf path<br>`value: string` - Setting value |
| `font_urls`            | `list of strings` | URLs to font archives to download and install.                                                                |
| `font_temp_dir`        | `string`          | Temporary directory for font downloads and extraction.                                                        |
| `cleanup_fonts`        | `boolean`         | Whether to remove the temporary font directory after installation (`true`/`false`).                           |


## Additional Resources

- [Ansible Community Documentation](https://docs.ansible.com/)
- [Awesome Ansible](https://github.com/ansible-community/awesome-ansible/blob/main/README.md)
- [Fedora Docs](https://docs.fedoraproject.org/)

## License

This project is licensed under GPL-3.0-or-later - see the [LICENSE](LICENSE) file for details.
