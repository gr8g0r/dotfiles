#!/bin/bash

# Setup script to create encrypted secrets file
# This script helps you create and encrypt your environment variables

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SECRETS_FILE="${SCRIPT_DIR}/secrets.env"
ENCRYPTED_FILE="${SCRIPT_DIR}/secrets.env.gpg"
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

# Check if GPG key exists
check_gpg_key() {
    if ! gpg --list-keys "$KEY_ID" >/dev/null 2>&1; then
        log_error "GPG key $KEY_ID not found. Please ensure your key is available."
        exit 1
    fi
    log_success "GPG key found: $KEY_ID"
}

# Create sample secrets file
create_sample_secrets() {
    log_info "Creating sample secrets file..."
    
    cat > "$SECRETS_FILE" << 'EOF'
# Environment Variables - Encrypted with GPG
# Add your sensitive environment variables here
# Each line should be in the format: export VARIABLE_NAME=value

# Example variables (replace with your actual values):
export API_KEY=your_api_key_here
export SECRET_TOKEN=your_secret_token_here
export DATABASE_URL=postgresql://user:password@localhost:5432/dbname
export AWS_ACCESS_KEY_ID=your_aws_access_key
export AWS_SECRET_ACCESS_KEY=your_aws_secret_key
export DOCKER_REGISTRY_PASSWORD=your_docker_password

# Add more variables as needed
# export CUSTOM_VAR=your_value
EOF
    
    log_success "Sample secrets file created: $SECRETS_FILE"
    log_warning "Please edit $SECRETS_FILE with your actual values before encrypting!"
}

# Encrypt the secrets file
encrypt_secrets() {
    log_info "Encrypting secrets file..."
    
    if [[ ! -f "$SECRETS_FILE" ]]; then
        log_error "Secrets file not found: $SECRETS_FILE"
        log_info "Run this script first to create the sample file."
        exit 1
    fi
    
    # Encrypt the file
    if gpg -e -r "$KEY_ID" "$SECRETS_FILE"; then
        log_success "File encrypted successfully: $SECRETS_FILE.gpg"
        
        # Move to expected location
        mv "$SECRETS_FILE.gpg" "$ENCRYPTED_FILE"
        log_success "Encrypted file moved to: $ENCRYPTED_FILE"
        
        # Remove plain text file
        rm -f "$SECRETS_FILE"
        log_info "Plain text file removed for security"
        
    else
        log_error "Failed to encrypt file. Please check your GPG key and passphrase."
        exit 1
    fi
}

# Main execution
main() {
    log_info "Setting up encrypted secrets file..."
    
    check_gpg_key
    
    if [[ -f "$ENCRYPTED_FILE" ]]; then
        log_warning "Encrypted file already exists: $ENCRYPTED_FILE"
        read -p "Do you want to overwrite it? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Setup cancelled."
            exit 0
        fi
        rm -f "$ENCRYPTED_FILE"
    fi
    
    if [[ ! -f "$SECRETS_FILE" ]]; then
        create_sample_secrets
        log_info "Please edit $SECRETS_FILE with your actual values, then run this script again to encrypt."
        log_info "You can edit it with: nano $SECRETS_FILE"
        exit 0
    else
        encrypt_secrets
        log_success "Setup complete! You can now use the decrypt_and_export.sh script."
        log_info "To test: source decrypt_and_export.sh --load-only"
    fi
}

main "$@"
