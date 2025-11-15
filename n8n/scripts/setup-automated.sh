#!/bin/bash

##############################################################################
# OBxFlow Automated Setup Script (Non-Interactive)
# 
# This script automatically initializes N8N without prompts
##############################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() { echo -e "${BLUE}ℹ${NC} $1"; }
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_header() { echo ""; echo "========================================"; echo "$1"; echo "========================================"; echo ""; }

command_exists() { command -v "$1" >/dev/null 2>&1; }
generate_password() { openssl rand -base64 32 | tr -d "=+/" | cut -c1-32; }
generate_encryption_key() { openssl rand -hex 32; }

##############################################################################
# Main Script
##############################################################################

print_header "OBxFlow Automated Setup - N8N Configuration"

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

# Backup existing .env if present
if [ -f ".env" ]; then
    print_warning ".env file already exists - backing up to .env.backup"
    mv .env .env.backup.$(date +%Y%m%d_%H%M%S)
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
    sed -i '' "s/GENERATE_WITH_openssl_rand_hex_32/${ENCRYPTION_KEY}/" .env
    sed -i '' "s/CHANGE_ME_SECURE_DB_PASSWORD/${DB_PASSWORD}/g" .env
    sed -i '' "s/CHANGE_ME_STRONG_PASSWORD/${ADMIN_PASSWORD}/" .env
else
    sed -i "s/GENERATE_WITH_openssl_rand_hex_32/${ENCRYPTION_KEY}/" .env
    sed -i "s/CHANGE_ME_SECURE_DB_PASSWORD/${DB_PASSWORD}/g" .env
    sed -i "s/CHANGE_ME_STRONG_PASSWORD/${ADMIN_PASSWORD}/" .env
fi

print_success ".env file configured"

# Save credentials to file
CREDS_FILE="obxflow_credentials_$(date +%Y%m%d_%H%M%S).txt"
cat > "$CREDS_FILE" << EOF
========================================
OBxFlow Credentials
Generated: $(date)
========================================

N8N Web Interface: http://localhost:5678

Admin Username: admin
Admin Password: ${ADMIN_PASSWORD}

Database User: n8n_user
Database Password: ${DB_PASSWORD}

Encryption Key: ${ENCRYPTION_KEY}

========================================
⚠️  SAVE THESE CREDENTIALS SECURELY! ⚠️
Store in password manager and delete this file.
========================================
EOF

print_success "Credentials saved to: $CREDS_FILE"

# Update credentials documentation
CRED_DOC="../.ai/05-CREDENTIALS.md"
if [ -f "$CRED_DOC" ]; then
    print_info "Updating credentials documentation..."
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/Username: \[TO_BE_CONFIGURED\]/Username: admin/" "$CRED_DOC"
        sed -i '' "s/Password: \[TO_BE_CONFIGURED\]/Password: ${ADMIN_PASSWORD}/" "$CRED_DOC"
        sed -i '' "s/N8N_ENCRYPTION_KEY=\[TO_BE_GENERATED\]/N8N_ENCRYPTION_KEY=${ENCRYPTION_KEY}/" "$CRED_DOC"
        sed -i '' "s/DB_POSTGRESDB_USER=\[TO_BE_CONFIGURED\]/DB_POSTGRESDB_USER=n8n_user/" "$CRED_DOC"
        sed -i '' "s/DB_POSTGRESDB_PASSWORD=\[TO_BE_CONFIGURED\]/DB_POSTGRESDB_PASSWORD=${DB_PASSWORD}/" "$CRED_DOC"
        sed -i '' "s/POSTGRES_PASSWORD=\[TO_BE_CONFIGURED\]/POSTGRES_PASSWORD=${DB_PASSWORD}/" "$CRED_DOC"
    else
        sed -i "s/Username: \[TO_BE_CONFIGURED\]/Username: admin/" "$CRED_DOC"
        sed -i "s/Password: \[TO_BE_CONFIGURED\]/Password: ${ADMIN_PASSWORD}/" "$CRED_DOC"
        sed -i "s/N8N_ENCRYPTION_KEY=\[TO_BE_GENERATED\]/N8N_ENCRYPTION_KEY=${ENCRYPTION_KEY}/" "$CRED_DOC"
        sed -i "s/DB_POSTGRESDB_USER=\[TO_BE_CONFIGURED\]/DB_POSTGRESDB_USER=n8n_user/" "$CRED_DOC"
        sed -i "s/DB_POSTGRESDB_PASSWORD=\[TO_BE_CONFIGURED\]/DB_POSTGRESDB_PASSWORD=${DB_PASSWORD}/" "$CRED_DOC"
        sed -i "s/POSTGRES_PASSWORD=\[TO_BE_CONFIGURED\]/POSTGRES_PASSWORD=${DB_PASSWORD}/" "$CRED_DOC"
    fi
    
    print_success "Credentials documented"
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

# Start services
print_header "Starting Docker Services"

print_info "Pulling Docker images..."
docker-compose pull

print_info "Starting services..."
docker-compose up -d

print_success "Services started!"

# Wait for services
print_info "Waiting for services to initialize..."
sleep 15

# Check service status
print_info "Checking service health..."
docker-compose ps

# Wait for N8N to be fully ready
print_info "Waiting for N8N to be ready..."
RETRIES=0
MAX_RETRIES=30

while [ $RETRIES -lt $MAX_RETRIES ]; do
    if curl -s http://localhost:5678/healthz > /dev/null 2>&1; then
        print_success "N8N is ready!"
        break
    fi
    RETRIES=$((RETRIES+1))
    echo -n "."
    sleep 2
done
echo ""

if [ $RETRIES -eq $MAX_RETRIES ]; then
    print_warning "N8N health check timed out, but services are running"
    print_info "Check logs: docker-compose logs -f n8n"
fi

# Summary
print_header "Setup Complete!"

cat << EOF
✅ Configuration file created: .env
✅ Secure credentials generated
✅ Docker Compose validated
✅ Directories created
✅ Docker images pulled
✅ Services started

========================================
N8N Access Information
========================================

URL: http://localhost:5678

Username: admin
Password: ${ADMIN_PASSWORD}

Credentials saved to: ${CREDS_FILE}

========================================
Next Steps
========================================

1. Access N8N:
   open http://localhost:5678

2. View logs:
   docker-compose logs -f

3. Check status:
   docker-compose ps

4. Create backup:
   ./scripts/backup.sh

5. Review credentials file:
   cat ${CREDS_FILE}

⚠️  IMPORTANT: Save credentials in password manager
⚠️  Then delete the credentials file for security

========================================
EOF

print_success "OBxFlow setup completed successfully!"

# Display service status
echo ""
print_info "Current service status:"
docker-compose ps

echo ""
print_success "🎉 N8N is now running at http://localhost:5678"
