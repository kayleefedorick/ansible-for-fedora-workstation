# Ansible for Fedora Workstation

Configure and manage [Fedora](https://fedoraproject.org/) Workstation 43 using [Ansible](https://github.com/ansible/ansible). Fedora Workstation is a polished, easy to use operating system for laptop and desktop computers, with a complete set of tools for developers and makers of all kinds. Ansible is a suite of software tools that enables infrastructure as code.

This repository contains IaC that automates the post-installation tasks for AMD-based x86-64 desktop computer using Fedora Workstation 43. Tasks include the installation of RPM and Flatpak packages needed for system administration, development, leisure and gaming.

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
git clone https://codeberg.org/artnay/ansible-for-fedora-workstation.git && cd ansible-for-fedora-workstation
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

## Additional Resources

- [Ansible Community Documentation](https://docs.ansible.com/)
- [Awesome Ansible](https://github.com/ansible-community/awesome-ansible/blob/main/README.md)
- [Fedora Docs](https://docs.fedoraproject.org/)

## License

This project is licensed under GPL-3.0-or-later - see the [LICENSE](LICENSE) file for details.
