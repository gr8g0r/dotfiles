# GPG Encrypted Environment Variables

This directory contains scripts for securely managing environment variables using GPG encryption. The system allows you to store sensitive configuration data in encrypted files and automatically load them into your shell environment.

## Features

- 🔐 **GPG Encryption**: Uses your personal GPG key for secure encryption
- 🔄 **Auto-loading**: Can be configured to automatically load variables on shell startup
- 🛡️ **Security**: Encrypted files are safe to commit to version control
- 🎨 **Colored Output**: User-friendly colored logging and status messages
- 🔧 **Flexible**: Supports both manual and automatic loading modes

## Prerequisites

- GPG key
- Bash shell
- `gpg` command-line tool

## Quick Start

### 1. Set up your encrypted secrets file

```bash
# Make scripts executable
chmod +x decrypt_and_export.sh setup_encrypted_secrets.sh

# Create and encrypt your secrets
./setup_encrypted_secrets.sh
```

This will:
- Create a sample `secrets.env` file with example variables
- Prompt you to edit it with your actual values
- Encrypt the file using your GPG key
- Remove the plain text file for security

### 2. Load variables for current session

```bash
# Load variables into current shell session
source ./decrypt_and_export.sh --load-only
```

### 3. Install for automatic loading (optional)

```bash
# Install to bash profile for automatic loading on new shell sessions
./decrypt_and_export.sh --install
```

## Scripts

### `decrypt_and_export.sh`

Main script for decrypting and exporting environment variables.

**Usage:**
```bash
# Load variables for current session
./decrypt_and_export.sh

# Load variables only (for sourcing)
source ./decrypt_and_export.sh --load-only

# Install to bash profile for auto-loading
./decrypt_and_export.sh --install

# Show help
./decrypt_and_export.sh --help
```

**Features:**
- Validates GPG key availability
- Checks for encrypted file existence
- Decrypts file using your GPG key
- Exports variables to current shell session
- Can be integrated into bash profile for automatic loading
- Creates backups before modifying bash profile
- Colored output for better user experience

### `setup_encrypted_secrets.sh`

Helper script to create and encrypt your secrets file.

**Usage:**
```bash
./setup_encrypted_secrets.sh
```

**Features:**
- Creates sample `secrets.env` file with common variable examples
- Encrypts the file using your GPG key
- Removes plain text file after encryption
- Interactive prompts for overwriting existing files

## File Structure

```
gpg/
├── decrypt_and_export.sh      # Main decryption script
├── setup_encrypted_secrets.sh # Setup helper script
├── secrets.env.gpg           # Encrypted environment variables (created by setup)
└── README.md                 # This documentation
```

## Security Notes

- The encrypted `secrets.env.gpg` file is safe to commit to version control
- Plain text `secrets.env` files are automatically removed after encryption
- The script uses your personal GPG key for encryption/decryption
- Temporary files are securely cleaned up after use
- Bash profile modifications are backed up before changes

## Example Variables

Your `secrets.env` file can contain any environment variables:

```bash
# API Keys
export API_KEY=your_api_key_here
export SECRET_TOKEN=your_secret_token_here

# Database
export DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# Cloud Services
export AWS_ACCESS_KEY_ID=your_aws_access_key
export AWS_SECRET_ACCESS_KEY=your_aws_secret_key

# Docker
export DOCKER_REGISTRY_PASSWORD=your_docker_password

# Kubernetes
export KUBECONFIG_PATH=/path/to/your/kubeconfig

# Custom variables
export CUSTOM_VAR=your_value
```

## Troubleshooting

### GPG Key Issues
- Ensure your GPG key is available: `gpg --list-keys`
- Check key ID matches: `$KEYID`

### File Not Found
- Run `./setup_encrypted_secrets.sh` to create the encrypted file
- Check file permissions on scripts

### Decryption Fails
- Verify your GPG passphrase is correct
- Ensure the encrypted file was created with your key
- Check file integrity: `gpg --verify secrets.env.gpg`

### Bash Profile Issues
- Script creates backups before modifying `.bashrc`
- Check for existing entries to avoid duplicates
- Manual backup: `cp ~/.bashrc ~/.bashrc.backup`

## Advanced Usage

### Manual Encryption
```bash
# Create your secrets file
nano secrets.env

# Encrypt manually
gpg -e -r '$KEYID' secrets.env

# Move to expected location
mv secrets.env.gpg ./secrets.env.gpg
```

### Custom Bash Profile
```bash
# Use different bash profile
BASH_PROFILE=~/.bash_profile ./decrypt_and_export.sh --install
```

### Script Integration
```bash
# Source in other scripts
source ./decrypt_and_export.sh --load-only

# Use variables in your script
echo "API Key: $API_KEY"
```

## Contributing

When modifying the scripts:
- Maintain backward compatibility
- Test with different shell configurations
- Update documentation for new features
- Follow the existing code style and error handling patterns 