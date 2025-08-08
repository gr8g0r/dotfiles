# gricas/dotfiles

This repository contains my personal dotfiles and scripts for managing development environments, secrets, and GPG keys, with a focus on automation, security, and portability—especially for Raspberry Pi and Linux systems.

---

## Table of Contents

- [Overview](#overview)
- [Directory Structure](#directory-structure)
- [Features](#features)
- [Getting Started](#getting-started)
- [GPG Encrypted Environment Variables](#gpg-encrypted-environment-variables)
  - [Quick Start](#quick-start)
  - [Scripts](#scripts)
  - [Security Notes](#security-notes)
  - [Troubleshooting](#troubleshooting)
- [GPG Key Transfer Guide](#gpg-key-transfer-guide)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

This repository provides:

- **Dotfiles** for shell and development environment configuration.
- **Scripts** for securely managing environment variables using GPG encryption.
- **Guides and tools** for transferring GPG keys between devices (e.g., Raspberry Pi).
- **Automation** for loading secrets into your shell environment.

---

## Directory Structure

```txt
├── LICENSE
├── README.md
└── scripts
    └── gpg
        ├── decrypt_and_export.sh
        ├── GPG_TRANSFER_GUIDE.md
        ├── README.md
        ├── setup_encrypted_secrets.sh
        └── transfer_gpg_key.sh
```
