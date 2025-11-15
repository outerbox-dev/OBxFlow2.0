#!/bin/bash

##############################################################################
# OBxFlow Setup Script
# 
# This script helps initialize the N8N environment for OBxFlow2.0
# It will:
#   - Check prerequisites
#   - Generate secure credentials
#   - Create .env file from template
#   - Validate configuration
#
# Usage: ./setup.sh
##############################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_header() {
    echo ""
    echo "========================================"
    echo "$1"
    echo "========================================"
    echo ""
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Generate secure password
generate_password() {
    openssl rand -base64 32 | tr -d "=+/" | cut -c1-32
}

# Generate encryption key
generate_encryption_key() {
    openssl rand -hex 32
}

##############################################################################
# Main Script
##############################################################################

print_header "OBxFlow Setup - N8N Configuration"

# Check prerequisites
print_info "Checking prerequisites..."

if ! command_exists docker; then
    print_error "Docker is not installed. Please install Docker Desktop."
    exit 1
fi
print_success "Docker found"

if ! command_exists docker-compose; then
    print_error "Docker Compose is not installed."
    exit 1
fi
print_success "Docker Compose found"

if ! command_exists openssl; then
    print_error "OpenSSL is not installed."
    exit 1
fi
print_success "OpenSSL found"

# Check if .env already exists
if [ -f ".env" ]; then
    print_warning ".env file already exists!"
    read -p "Do you want to overwrite it? (yes/no): " -r
    echo
    if [[ ! $REPLY =~ ^[Yy]es$ ]]; then
        print_info "Setup cancelled. Existing .env file preserved."
        exit 0
    fi
    mv .env .env.backup
    print_success "Backed up existing .env to .env.backup"
fi

# Copy template
print_info "Creating .env from template..."
if [ ! -f ".env.example" ]; then
    print_error ".env.example not found!"
    exit 1
fi

cp .env.example .env
print_success ".env created"

# Generate credentials
print_header "Generating Secure Credentials"

print_info "Generating encryption key..."
ENCRYPTION_KEY=$(generate_encryption_key)
print_success "Encryption key generated"

print_info "Generating database password..."
DB_PASSWORD=$(generate_password)
print_success "Database password generated"

print_info "Generating admin password..."
ADMIN_PASSWORD=$(generate_password)
print_success "Admin password generated"

# Update .env file
print_info "Updating .env with generated credentials..."

# For macOS and Linux compatibility
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s/GENERATE_WITH_openssl_rand_hex_32/${ENCRYPTION_KEY}/" .env
    sed -i '' "s/CHANGE_ME_SECURE_DB_PASSWORD/${DB_PASSWORD}/g" .env
    sed -i '' "s/CHANGE_ME_STRONG_PASSWORD/${ADMIN_PASSWORD}/" .env
else
    # Linux
    sed -i "s/GENERATE_WITH_openssl_rand_hex_32/${ENCRYPTION_KEY}/" .env
    sed -i "s/CHANGE_ME_SECURE_DB_PASSWORD/${DB_PASSWORD}/g" .env
    sed -i "s/CHANGE_ME_STRONG_PASSWORD/${ADMIN_PASSWORD}/" .env
fi

print_success ".env file configured with secure credentials"

# Display credentials
print_header "Generated Credentials"
echo "⚠️  SAVE THESE CREDENTIALS SECURELY! ⚠️"
echo ""
echo "Admin Username: admin"
echo "Admin Password: ${ADMIN_PASSWORD}"
echo ""
echo "Database Password: ${DB_PASSWORD}"
echo ""
echo "Encryption Key: ${ENCRYPTION_KEY}"
echo ""
print_warning "These credentials are saved in the .env file"
print_warning "Store them in a password manager!"
echo ""

# Create credentials file
CRED_FILE="../.ai/05-CREDENTIALS.md"
if [ -f "$CRED_FILE" ]; then
    print_info "Updating credentials in .ai/05-CREDENTIALS.md..."
    
    # Backup existing
    cp "$CRED_FILE" "$CRED_FILE.backup"
    
    # Update with actual values
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/N8N_BASIC_AUTH_USER=\[TO_BE_CONFIGURED\]/N8N_BASIC_AUTH_USER=admin/" "$CRED_FILE"
        sed -i '' "s/N8N_BASIC_AUTH_PASSWORD=\[TO_BE_CONFIGURED\]/N8N_BASIC_AUTH_PASSWORD=${ADMIN_PASSWORD}/" "$CRED_FILE"
        sed -i '' "s/N8N_ENCRYPTION_KEY=\[TO_BE_GENERATED\]/N8N_ENCRYPTION_KEY=${ENCRYPTION_KEY}/" "$CRED_FILE"
        sed -i '' "s/DB_POSTGRESDB_PASSWORD=\[TO_BE_CONFIGURED\]/DB_POSTGRESDB_PASSWORD=${DB_PASSWORD}/" "$CRED_FILE"
    else
        sed -i "s/N8N_BASIC_AUTH_USER=\[TO_BE_CONFIGURED\]/N8N_BASIC_AUTH_USER=admin/" "$CRED_FILE"
        sed -i "s/N8N_BASIC_AUTH_PASSWORD=\[TO_BE_CONFIGURED\]/N8N_BASIC_AUTH_PASSWORD=${ADMIN_PASSWORD}/" "$CRED_FILE"
        sed -i "s/N8N_ENCRYPTION_KEY=\[TO_BE_GENERATED\]/N8N_ENCRYPTION_KEY=${ENCRYPTION_KEY}/" "$CRED_FILE"
        sed -i "s/DB_POSTGRESDB_PASSWORD=\[TO_BE_CONFIGURED\]/DB_POSTGRESDB_PASSWORD=${DB_PASSWORD}/" "$CRED_FILE"
    fi
    
    print_success "Credentials documented in .ai/05-CREDENTIALS.md"
fi

# Validate Docker Compose
print_header "Validating Configuration"

print_info "Validating docker-compose.yml..."
if docker-compose config > /dev/null 2>&1; then
    print_success "docker-compose.yml is valid"
else
    print_error "docker-compose.yml has errors!"
    docker-compose config
    exit 1
fi

# Create necessary directories
print_info "Creating directories..."
mkdir -p backups logs data
print_success "Directories created"

# Summary
print_header "Setup Complete!"

echo "✅ Configuration file created: .env"
echo "✅ Secure credentials generated"
echo "✅ Docker Compose validated"
echo "✅ Directories created"
echo ""
echo "Next steps:"
echo ""
echo "1. Review your .env file:"
echo "   nano .env"
echo ""
echo "2. Start N8N services:"
echo "   docker-compose up -d"
echo ""
echo "3. View logs:"
echo "   docker-compose logs -f"
echo ""
echo "4. Access N8N:"
echo "   http://localhost:5678"
echo ""
echo "5. Login with:"
echo "   Username: admin"
echo "   Password: ${ADMIN_PASSWORD}"
echo ""
print_warning "IMPORTANT: Save your credentials in a password manager!"
print_warning "The .env file contains sensitive information."
echo ""

# Ask if user wants to start services
read -p "Do you want to start N8N services now? (yes/no): " -r
echo
if [[ $REPLY =~ ^[Yy]es$ ]]; then
    print_info "Starting Docker services..."
    docker-compose up -d
    
    print_success "Services started!"
    echo ""
    print_info "Waiting for services to be ready..."
    sleep 10
    
    print_info "Checking service status..."
    docker-compose ps
    
    echo ""
    print_success "Setup complete! N8N should be available at http://localhost:5678"
    print_info "It may take a minute for all services to fully initialize."
else
    print_info "Services not started. Run 'docker-compose up -d' when ready."
fi

echo ""
print_success "OBxFlow setup completed successfully!"
