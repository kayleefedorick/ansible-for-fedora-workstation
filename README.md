# Ansible for Fedora Workstation

Configure and manage [Fedora](https://fedoraproject.org/) Workstation 42 using [Ansible](https://github.com/ansible/ansible) infrastructure as code. Fedora Workstation is a polished, easy to use operating system for laptop and desktop computers, with a complete set of tools for developers and makers of all kinds. Ansible is a suite of software tools that enables infrastructure as code.

This repository contains IaC that automates the post-installation tasks for AMD-based x86-64 desktop computer using Fedora Workstation 42. Tasks include the installation of RPM and Flatpak packages needed for system administration, development, leisure and gaming.

- [Ansible for Fedora Workstation](#ansible-for-fedora-workstation)
   * [Prerequisites](#prerequisites)
   * [Preparations](#preparations)
      + [Download and check the disk image](#download-and-check-the-disk-image)
      + [OS and Ansible Installation](#os-and-ansible-installation)
   * [Usage](#usage)
      + [Basic Commands](#basic-commands)
      + [Running Playbook](#running-playbook)
   * [Additional Resources](#additional-resources)
   * [License](#license)

## Prerequisites

- Fedora Workstation 42 (x86-64)
- Ansible core 2.18.3

## Preparations

### Download and check the disk image

Download the [Fedora Workstation 42 ISO image](https://download.fedoraproject.org/pub/fedora/linux/releases/42/Workstation/x86_64/iso/Fedora-Workstation-Live-42-1.1.x86_64.iso).

Check the hash for the downloaded image:

```bash
sha512sum Fedora-Workstation-Live-42-1.1.x86_64.iso
```

Ensure the output value:

```bash
8af5430c8596a2d540cf0ece6c2b823b714ca436ab4b859b111c7d1ffe5e88f970415f52b6c4a4bf19ecd6aa4e64ea35775269496f443ede7d654e292b52239e
```

### OS and Ansible Installation

Install Fedora using previously downloaded image. After installation has finished, login and install Ansible:

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

## License

This project is licensed under GPL-3.0-or-later - see the [LICENSE](LICENSE) file for details.