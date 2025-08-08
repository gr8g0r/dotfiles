#!/bin/bash

# GPG Key Transfer Script for Raspberry Pi
# This script helps transfer GPG keys between Pi devices on the same network

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${SCRIPT_DIR}/gpg_backup"
KEY_ID=""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show usage
show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Options:
    --export          Export GPG key to backup directory
    --import          Import GPG key from backup directory
    --transfer        Transfer key to another Pi (interactive)
    --list-keys       List available GPG keys
    --help            Show this help message

Examples:
    # Export your GPG key
    $0 --export
    
    # Import GPG key on target Pi
    $0 --import
    
    # Interactive transfer to another Pi
    $0 --transfer
    
    # List available keys
    $0 --list-keys
EOF
}

# Function to check if GPG key exists
check_gpg_key() {
    if ! gpg --list-keys "$KEY_ID" >/dev/null 2>&1; then
        log_error "GPG key $KEY_ID not found."
        exit 1
    fi
    log_success "GPG key found: $KEY_ID"
}

# Function to export GPG key
export_gpg_key() {
    log_info "Exporting GPG key..."
    
    # Create backup directory
    mkdir -p "$BACKUP_DIR"
    
    # Export public key
    gpg --armor --export "$KEY_ID" > "$BACKUP_DIR/public_key.asc"
    log_success "Public key exported: $BACKUP_DIR/public_key.asc"
    
    # Export private key (encrypted)
    gpg --armor --export-secret-key "$KEY_ID" > "$BACKUP_DIR/private_key.asc"
    log_success "Private key exported: $BACKUP_DIR/private_key.asc"
    
    # Export key configuration
    gpg --export-ownertrust > "$BACKUP_DIR/ownertrust.txt"
    log_success "Owner trust exported: $BACKUP_DIR/ownertrust.txt"
    
    # Create transfer script
    cat > "$BACKUP_DIR/transfer_script.sh" << 'EOF'
#!/bin/bash
# GPG Key Transfer Script for Target Pi

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log_info() {
    echo -e "\033[0;34m[INFO]\033[0m $1"
}

log_success() {
    echo -e "\033[0;32m[SUCCESS]\033[0m $1"
}

log_error() {
    echo -e "\033[0;31m[ERROR]\033[0m $1"
}

log_info "Importing GPG key..."

# Import public key
gpg --import "$SCRIPT_DIR/public_key.asc"
log_success "Public key imported"

# Import private key
gpg --import "$SCRIPT_DIR/private_key.asc"
log_success "Private key imported"

# Import owner trust
gpg --import-ownertrust "$SCRIPT_DIR/ownertrust.txt"
log_success "Owner trust imported"

log_success "GPG key transfer complete!"
log_info "You can now use the decrypt_and_export.sh script on this Pi."
EOF
    
    chmod +x "$BACKUP_DIR/transfer_script.sh"
    log_success "Transfer script created: $BACKUP_DIR/transfer_script.sh"
    
    log_info "Backup files created in: $BACKUP_DIR"
    log_info "Copy this directory to your target Pi and run transfer_script.sh"
}

# Function to import GPG key
import_gpg_key() {
    log_info "Importing GPG key..."
    
    if [[ ! -d "$BACKUP_DIR" ]]; then
        log_error "Backup directory not found: $BACKUP_DIR"
        log_info "Please copy the gpg_backup directory to this Pi first."
        exit 1
    fi
    
    # Import public key
    if [[ -f "$BACKUP_DIR/public_key.asc" ]]; then
        gpg --import "$BACKUP_DIR/public_key.asc"
        log_success "Public key imported"
    else
        log_error "Public key file not found"
        exit 1
    fi
    
    # Import private key
    if [[ -f "$BACKUP_DIR/private_key.asc" ]]; then
        gpg --import "$BACKUP_DIR/private_key.asc"
        log_success "Private key imported"
    else
        log_error "Private key file not found"
        exit 1
    fi
    
    # Import owner trust
    if [[ -f "$BACKUP_DIR/ownertrust.txt" ]]; then
        gpg --import-ownertrust "$BACKUP_DIR/ownertrust.txt"
        log_success "Owner trust imported"
    else
        log_error "Owner trust file not found"
        exit 1
    fi
    
    log_success "GPG key import complete!"
}

# Function to transfer key interactively
transfer_key() {
    log_info "Interactive GPG key transfer"
    
    # Get target Pi information
    read -p "Enter target Pi IP address: " target_ip
    read -p "Enter target Pi username: " target_user
    
    log_info "Transferring GPG key to $target_user@$target_ip..."
    
    # Export key first
    export_gpg_key
    
    # Create remote directory
    ssh -i ~/.ssh/id_rsa "$target_user@$target_ip" "mkdir -p ~/gpg_backup"
    
    # Copy backup files
    scp -i ~/.ssh/id_rsa -r "$BACKUP_DIR"/* "$target_user@$target_ip:~/gpg_backup/"
    
    # Run transfer script on target
    ssh "$target_user@$target_ip" "chmod +x ~/gpg_backup/transfer_script.sh && ~/gpg_backup/transfer_script.sh"
    
    log_success "GPG key transferred successfully!"
    log_info "You can now use the decrypt_and_export.sh script on the target Pi."
}

# Function to list keys
list_keys() {
    log_info "Available GPG keys:"
    gpg --list-keys
}

# Function to show network transfer methods
show_network_methods() {
    cat << EOF

Network Transfer Methods:

1. SCP (Secure Copy):
   # From source Pi to target Pi
   scp -r gpg_backup/ user@target-pi-ip:~/
   
   # Then on target Pi
   cd ~/gpg_backup && ./transfer_script.sh

2. rsync (Synchronization):
   # From source Pi to target Pi
   rsync -avz gpg_backup/ user@target-pi-ip:~/gpg_backup/
   
   # Then on target Pi
   cd ~/gpg_backup && ./transfer_script.sh

3. USB/SD Card:
   # Copy gpg_backup directory to USB/SD card
   cp -r gpg_backup/ /media/usb/
   
   # On target Pi, copy from USB/SD card
   cp -r /media/usb/gpg_backup/ ~/
   cd ~/gpg_backup && ./transfer_script.sh

4. SFTP:
   # Use SFTP client to transfer files
   sftp user@target-pi-ip
   put -r gpg_backup/
   
   # Then on target Pi
   cd ~/gpg_backup && ./transfer_script.sh

Security Notes:
- Always use encrypted connections (SSH, SCP, SFTP)
- Verify the target Pi's identity before transfer
- Keep backup files secure and delete after transfer
- Consider using a temporary password for the transfer
EOF
}

# Main execution
main() {
    case "${1:-}" in
        --export)
            check_gpg_key
            export_gpg_key
            show_network_methods
            ;;
        --import)
            import_gpg_key
            ;;
        --transfer)
            check_gpg_key
            transfer_key
            ;;
        --list-keys)
            list_keys
            ;;
        --help|-h)
            show_usage
            ;;
        "")
            show_usage
            ;;
        *)
            log_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
