#!/bin/bash

# Script to decrypt GPG-encrypted environment variables and export them to bash profile
# Author: grigore casim
# GPG Key: $KEYID

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENCRYPTED_FILE="${SCRIPT_DIR}/secrets.env.gpg"
BASH_PROFILE="${HOME}/.bashrc"
BACKUP_SUFFIX=".backup.$(date +%Y%m%d_%H%M%S)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
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

# Function to check if GPG key exists
check_gpg_key() {
    local key_id="$KEYID"
    
    if ! gpg --list-keys "$key_id" >/dev/null 2>&1; then
        log_error "GPG key $key_id not found. Please ensure your key is available."
        exit 1
    fi
    
    log_success "GPG key found: $key_id"
}

# Function to check if encrypted file exists
check_encrypted_file() {
    if [[ ! -f "$ENCRYPTED_FILE" ]]; then
        log_error "Encrypted file not found: $ENCRYPTED_FILE"
        log_info "Please create an encrypted file with your environment variables:"
        log_info "1. Create a file with your variables (e.g., secrets.env):"
        log_info "   export API_KEY=your_api_key"
        log_info "   export SECRET_TOKEN=your_secret_token"
        log_info "2. Encrypt it: gpg -e -r $key_id secrets.env"
        log_info "3. Rename to: mv secrets.env.gpg $ENCRYPTED_FILE"
        exit 1
    fi
    
    log_success "Encrypted file found: $ENCRYPTED_FILE"
}

# Function to decrypt and export variables
decrypt_and_export() {
    local temp_file=$(mktemp)
    local key_id="$KEYID"
    
    log_info "Decrypting file..."
    
    # Decrypt the file
    if ! gpg --decrypt --recipient "$key_id" "$ENCRYPTED_FILE" > "$temp_file" 2>/dev/null; then
        log_error "Failed to decrypt file. Please check your GPG key and passphrase."
        rm -f "$temp_file"
        exit 1
    fi
    
    log_success "File decrypted successfully"
    
    # Read and export variables
    log_info "Exporting variables to current session..."
    while IFS= read -r line; do
        # Skip empty lines and comments
        if [[ -n "$line" && ! "$line" =~ ^[[:space:]]*# ]]; then
            # Check if line contains export statement
            if [[ "$line" =~ ^[[:space:]]*export[[:space:]]+ ]]; then
                # Execute the export command
                eval "$line"
                log_info "Exported: ${line#export }"
            else
                # Add export if not present
                export_line="export $line"
                eval "$export_line"
                log_info "Exported: $line"
            fi
        fi
    done < "$temp_file"
    
    # Clean up temp file
    rm -f "$temp_file"
    
    log_success "Variables exported to current session"
}

# Function to add to bash profile
add_to_bash_profile() {
    local key_id="$KEYID
    
    log_info "Adding decryption script to bash profile..."
    
    # Create backup of bash profile
    if [[ -f "$BASH_PROFILE" ]]; then
        cp "$BASH_PROFILE" "${BASH_PROFILE}${BACKUP_SUFFIX}"
        log_info "Backup created: ${BASH_PROFILE}${BACKUP_SUFFIX}"
    fi
    
    # Check if script is already in bash profile
    if grep -q "decrypt_and_export.sh" "$BASH_PROFILE" 2>/dev/null; then
        log_warning "Script already exists in bash profile. Skipping addition."
        return 0
    fi
    
    # Add the script call to bash profile
    cat >> "$BASH_PROFILE" << EOF

# Auto-load encrypted environment variables
if [[ -f "${SCRIPT_DIR}/decrypt_and_export.sh" ]]; then
    source "${SCRIPT_DIR}/decrypt_and_export.sh" --load-only
fi
EOF
    
    log_success "Added to bash profile: $BASH_PROFILE"
}

# Function to load variables only (for sourcing)
load_only() {
    check_gpg_key
    check_encrypted_file
    decrypt_and_export
}

# Function to show usage
show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Options:
    --load-only      Only decrypt and export variables (for sourcing)
    --install        Install script to bash profile for auto-loading
    --help           Show this help message

Examples:
    # Load variables for current session only
    source $0 --load-only
    
    # Install to bash profile for auto-loading
    $0 --install
    
    # Run interactively (decrypt and export to current session)
    $0
EOF
}

# Main execution
main() {
    case "${1:-}" in
        --load-only)
            load_only
            ;;
        --install)
            check_gpg_key
            check_encrypted_file
            add_to_bash_profile
            log_success "Installation complete. Variables will be loaded automatically on new shell sessions."
            ;;
        --help|-h)
            show_usage
            ;;
        "")
            check_gpg_key
            check_encrypted_file
            decrypt_and_export
            log_success "Variables loaded successfully!"
            log_info "To make this permanent, run: $0 --install"
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
