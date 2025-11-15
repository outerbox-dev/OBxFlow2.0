#!/bin/bash

##############################################################################
# OBxFlow Backup Script
# 
# Creates a complete backup of:
#   - PostgreSQL database
#   - N8N workflows (as JSON)
#   - Configuration files
#
# Usage: ./backup.sh [backup-name]
##############################################################################

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_info() {
    echo -e "${GREEN}ℹ${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if docker-compose is running
if ! docker-compose ps | grep -q "Up"; then
    print_error "N8N services are not running!"
    print_info "Start services with: docker-compose up -d"
    exit 1
fi

# Backup name (default: timestamp)
BACKUP_NAME=${1:-backup_$(date +%Y%m%d_%H%M%S)}
BACKUP_DIR="../backups/${BACKUP_NAME}"

print_info "Creating backup: ${BACKUP_NAME}"

# Create backup directory
mkdir -p "${BACKUP_DIR}"

# Backup database
print_info "Backing up PostgreSQL database..."
docker-compose exec -T postgres pg_dump -U n8n_user -d n8n > "${BACKUP_DIR}/database.sql"

if [ $? -eq 0 ]; then
    SIZE=$(du -h "${BACKUP_DIR}/database.sql" | cut -f1)
    print_info "Database backup created (${SIZE})"
else
    print_error "Database backup failed!"
    exit 1
fi

# Backup N8N workflows
print_info "Exporting N8N workflows..."
docker-compose exec -T n8n n8n export:workflow --all --output=/tmp/workflows.json 2>/dev/null || true

if docker-compose exec -T n8n test -f /tmp/workflows.json 2>/dev/null; then
    docker-compose exec -T n8n cat /tmp/workflows.json > "${BACKUP_DIR}/workflows.json"
    docker-compose exec -T n8n rm /tmp/workflows.json
    print_info "Workflows exported"
else
    print_warning "No workflows to export or export failed"
fi

# Backup configuration
print_info "Backing up configuration..."
cp .env.example "${BACKUP_DIR}/.env.example"

# Create metadata file
cat > "${BACKUP_DIR}/backup_info.txt" << EOF
Backup Name: ${BACKUP_NAME}
Date: $(date)
Hostname: $(hostname)
N8N Version: $(docker-compose exec -T n8n n8n --version 2>/dev/null || echo "unknown")
Database Size: $(docker-compose exec postgres psql -U n8n_user -d n8n -t -c "SELECT pg_size_pretty(pg_database_size('n8n'));" 2>/dev/null || echo "unknown")
EOF

print_info "Backup metadata created"

# Compress backup
print_info "Compressing backup..."
cd ../backups
tar -czf "${BACKUP_NAME}.tar.gz" "${BACKUP_NAME}"
rm -rf "${BACKUP_NAME}"

COMPRESSED_SIZE=$(du -h "${BACKUP_NAME}.tar.gz" | cut -f1)
print_info "Backup compressed: ${COMPRESSED_SIZE}"

# Show backup details
echo ""
echo "========================================"
echo "Backup Complete!"
echo "========================================"
echo ""
echo "Location: backups/${BACKUP_NAME}.tar.gz"
echo "Size: ${COMPRESSED_SIZE}"
echo ""
echo "To restore this backup:"
echo "  ./scripts/restore.sh ${BACKUP_NAME}"
echo ""

# Cleanup old backups (keep last 30 days)
print_info "Cleaning up old backups..."
find . -name "backup_*.tar.gz" -mtime +30 -delete
print_info "Old backups removed (kept last 30 days)"

exit 0
