# GPG Key Transfer Guide for Raspberry Pi

This guide explains how to transfer your GPG key from one Raspberry Pi to another on the same network.

## Prerequisites

- Both Pi devices on the same network
- SSH access between devices
- GPG key already created on source Pi
- Network connectivity between devices

## Method 1: Automated Transfer (Recommended)

### Step 1: Export GPG Key on Source Pi

```bash
# Navigate to the scripts directory
cd ~/WORKSPACE/code/scripts/gpg

# Make the transfer script executable
chmod +x transfer_gpg_key.sh

# Export your GPG key

```

This will create a `gpg_backup` directory with:
- `public_key.asc` - Your public key
- `private_key.asc` - Your encrypted private key
- `ownertrust.txt` - Key trust settings
- `transfer_script.sh` - Automated import script

### Step 2: Transfer Files to Target Pi

Choose one of these methods:

#### Option A: SCP (Secure Copy)
```bash
# From source Pi, copy to target Pi
scp -r gpg_backup/ user@target-pi-ip:~/

# Example:
scp -r gpg_backup/ pi@192.168.1.100:~/
```

#### Option B: rsync (Synchronization)
```bash
# From source Pi, sync to target Pi
rsync -avz gpg_backup/ user@target-pi-ip:~/gpg_backup/

# Example:
rsync -avz gpg_backup/ pi@192.168.1.100:~/gpg_backup/
```

#### Option C: USB/SD Card
```bash
# Copy to USB/SD card
cp -r gpg_backup/ /media/usb/

# On target Pi, copy from USB/SD card
cp -r /media/usb/gpg_backup/ ~/
```

### Step 3: Import GPG Key on Target Pi

```bash
# On target Pi, navigate to backup directory
cd ~/gpg_backup

# Run the transfer script
./transfer_script.sh
```

## Method 2: Interactive Transfer

For a fully automated process:

```bash
# On source Pi, run interactive transfer
./transfer_gpg_key.sh --transfer
```

This will prompt for:
- Target Pi IP address
- Target Pi username
- Automatically handle the entire transfer process

## Method 3: Manual Transfer

### Step 1: Export Key Components

On the source Pi:

```bash
# Export public key
gpg --armor --export <KEYID> > public_key.asc

# Export private key (will prompt for passphrase)
gpg --armor --export-secret-key  <KEYID> > private_key.asc

# Export trust settings
gpg --export-ownertrust > ownertrust.txt
```

### Step 2: Transfer Files

Use any of the network methods above to transfer:
- `public_key.asc`
- `private_key.asc`
- `ownertrust.txt`

### Step 3: Import on Target Pi

On the target Pi:

```bash
# Import public key
gpg --import public_key.asc

# Import private key (will prompt for passphrase)
gpg --import private_key.asc

# Import trust settings
gpg --import-ownertrust ownertrust.txt
```

## Verification

After transfer, verify the key is working:

```bash
# List keys
gpg --list-keys

# Test decryption (if you have encrypted files)
./decrypt_and_export.sh --load-only
```

## Security Considerations

### Before Transfer
- Ensure both Pi devices are on a secure network
- Verify the target Pi's identity
- Use strong SSH keys for authentication
- Consider using a temporary password for the transfer

### During Transfer
- Use encrypted connections (SSH, SCP, SFTP)
- Avoid transferring over unsecured networks
- Keep backup files secure during transfer

### After Transfer
- Delete backup files from source Pi
- Delete backup files from target Pi after successful import
- Verify the key works correctly on target Pi
- Consider changing the GPG passphrase on target Pi

## Troubleshooting

### Common Issues

#### 1. "Permission denied" errors
```bash
# Fix file permissions
chmod 600 private_key.asc
chmod 644 public_key.asc
```

#### 2. "No such file or directory"
```bash
# Check if files exist
ls -la gpg_backup/

# Verify file paths
pwd
```

#### 3. "GPG key not found"
```bash
# Check if key exists
gpg --list-keys

# Verify key ID
gpg --list-keys $KEYID
```

#### 4. "Import failed"
```bash
# Check GPG version compatibility
gpg --version

# Try importing with verbose output
gpg --verbose --import private_key.asc
```

### Network Issues

#### 1. SSH connection fails
```bash
# Test SSH connection
ssh user@target-pi-ip

# Check network connectivity
ping target-pi-ip
```

#### 2. SCP transfer fails
```bash
# Use verbose SCP for debugging
scp -v -r gpg_backup/ user@target-pi-ip:~/

# Check disk space on target
ssh user@target-pi-ip "df -h"
```

## Advanced Options

### Transfer Multiple Keys

If you have multiple GPG keys:

```bash
# Export all keys
gpg --armor --export > all_public_keys.asc
gpg --armor --export-secret-keys > all_private_keys.asc
gpg --export-ownertrust > all_ownertrust.txt

# Import all keys
gpg --import all_public_keys.asc
gpg --import all_private_keys.asc
gpg --import-ownertrust all_ownertrust.txt
```

### Backup Before Transfer

```bash
# Create full GPG backup
tar -czf gpg_backup_full.tar.gz ~/.gnupg/

# Restore on target Pi
tar -xzf gpg_backup_full.tar.gz -C ~/
```

### Key Verification

```bash
# Verify key fingerprint
gpg --fingerprint $KEYID

# Test encryption/decryption
echo "test" | gpg --encrypt --recipient $KEYID | gpg --decrypt
```

## Script Usage Examples

```bash
# Export key for manual transfer
./transfer_gpg_key.sh --export

# Import key from backup
./transfer_gpg_key.sh --import

# Interactive transfer to another Pi
./transfer_gpg_key.sh --transfer

# List available keys
./transfer_gpg_key.sh --list-keys

# Show help
./transfer_gpg_key.sh --help
```

## File Structure After Transfer

```
~/gpg_backup/
├── public_key.asc      # Public key
├── private_key.asc     # Private key (encrypted)
├── ownertrust.txt      # Trust settings
└── transfer_script.sh  # Import script
```

## Next Steps

After successful transfer:

1. **Test the key**: Run `./decrypt_and_export.sh --load-only`
2. **Set up encrypted secrets**: Run `./setup_encrypted_secrets.sh`
3. **Install auto-loading**: Run `./decrypt_and_export.sh --install`
4. **Clean up**: Delete backup files for security

## Support

If you encounter issues:

1. Check the troubleshooting section above
2. Verify network connectivity between Pi devices
3. Ensure GPG is properly installed on both devices
4. Check file permissions and ownership
5. Review GPG error messages for specific guidance
