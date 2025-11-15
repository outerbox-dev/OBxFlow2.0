#!/bin/bash

##############################################################################
# OBxFlow Restore Script
# 
# Restores N8N from a backup created by backup.sh
#
# Usage: ./restore.sh <backup-name>
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

# Check arguments
if [ -z "$1" ]; then
    print_error "Usage: ./restore.sh <backup-name>"
    echo ""
    echo "Available backups:"
    ls -1 ../backups/*.tar.gz 2>/dev/null | sed 's/.*\///' | sed 's/\.tar\.gz//' || echo "  No backups found"
    exit 1
fi

BACKUP_NAME=$1
BACKUP_FILE="../backups/${BACKUP_NAME}.tar.gz"

# Check if backup exists
if [ ! -f "${BACKUP_FILE}" ]; then
    print_error "Backup not found: ${BACKUP_FILE}"
    exit 1
fi

# Warning
echo ""
echo "========================================"
echo "⚠️  WARNING: DATA RESTORATION  ⚠️"
echo "========================================"
echo ""
echo "This will:"
echo "  1. Stop all N8N services"
echo "  2. Delete current database data"
echo "  3. Restore from backup: ${BACKUP_NAME}"
echo "  4. Restart services"
echo ""
print_warning "ALL CURRENT DATA WILL BE LOST!"
echo ""
read -p "Are you sure you want to continue? (type 'yes' to confirm): " -r
echo

if [[ ! $REPLY =~ ^yes$ ]]; then
    print_info "Restore cancelled"
    exit 0
fi

# Extract backup
print_info "Extracting backup..."
cd ../backups
tar -xzf "${BACKUP_NAME}.tar.gz"

if [ ! -d "${BACKUP_NAME}" ]; then
    print_error "Backup extraction failed!"
    exit 1
fi

# Check backup contents
if [ ! -f "${BACKUP_NAME}/database.sql" ]; then
    print_error "Database backup not found in archive!"
    rm -rf "${BACKUP_NAME}"
    exit 1
fi

# Stop services
cd ../
print_info "Stopping N8N services..."
docker-compose down

# Remove old data
print_info "Removing old database data..."
docker volume rm n8n_postgres_data 2>/dev/null || true

# Start only database first
print_info "Starting PostgreSQL..."
docker-compose up -d postgres

# Wait for database to be ready
print_info "Waiting for database to initialize..."
sleep 15

# Check database health
print_info "Checking database health..."
RETRIES=0
MAX_RETRIES=30

while [ $RETRIES -lt $MAX_RETRIES ]; do
    if docker-compose exec postgres pg_isready -U n8n_user 2>/dev/null; then
        print_info "Database is ready"
        break
    fi
    RETRIES=$((RETRIES+1))
    echo -n "."
    sleep 2
done

if [ $RETRIES -eq $MAX_RETRIES ]; then
    print_error "Database failed to start!"
    exit 1
fi

# Restore database
print_info "Restoring database..."
docker-compose exec -T postgres psql -U n8n_user -d n8n < "backups/${BACKUP_NAME}/database.sql"

if [ $? -eq 0 ]; then
    print_info "Database restored successfully"
else
    print_error "Database restore failed!"
    exit 1
fi

# Start N8N
print_info "Starting N8N..."
docker-compose up -d n8n

# Wait for N8N to be ready
print_info "Waiting for N8N to initialize..."
sleep 10

# Restore workflows (if available)
if [ -f "backups/${BACKUP_NAME}/workflows.json" ]; then
    print_info "Restoring workflows..."
    docker-compose cp "backups/${BACKUP_NAME}/workflows.json" n8n:/tmp/workflows.json
    docker-compose exec -T n8n n8n import:workflow --input=/tmp/workflows.json 2>/dev/null || print_warning "Workflow import may have issues - check manually"
    docker-compose exec -T n8n rm /tmp/workflows.json 2>/dev/null || true
fi

# Cleanup
print_info "Cleaning up..."
rm -rf "backups/${BACKUP_NAME}"

# Check services
print_info "Checking service status..."
docker-compose ps

# Summary
echo ""
echo "========================================"
echo "Restore Complete!"
echo "========================================"
echo ""
echo "Services Status:"
docker-compose ps
echo ""
echo "N8N should be available at: http://localhost:5678"
echo ""
print_warning "Please verify all workflows work correctly"
echo ""

exit 0
