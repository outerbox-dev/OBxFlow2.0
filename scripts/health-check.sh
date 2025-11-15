#!/bin/bash
# OBxFlow Health Check Script
# Monitors the health of N8N and related services

set -e

PROJECT_DIR="$HOME/Projects/OBxFlow2.0"
HEALTH_LOG="$PROJECT_DIR/logs/health-check.log"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Create log directory if it doesn't exist
mkdir -p "$PROJECT_DIR/logs"

# Timestamp
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo ""
echo "🏥 OBxFlow Health Check"
echo "======================="
echo "Time: $TIMESTAMP"
echo ""

# Function to check service
check_service() {
    local name=$1
    local check_cmd=$2
    local status_var=$3
    
    if eval "$check_cmd" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ $name${NC}"
        eval "$status_var=1"
    else
        echo -e "${RED}❌ $name${NC}"
        eval "$status_var=0"
    fi
}

# Check Docker
echo "📦 Docker Services"
echo "-------------------"
check_service "Docker Desktop" "docker info" DOCKER_OK

if [ $DOCKER_OK -eq 1 ]; then
    cd "$PROJECT_DIR/n8n"
    
    # Check PostgreSQL
    PG_STATUS=$(docker-compose ps postgres --status running -q 2>/dev/null)
    if [ -n "$PG_STATUS" ]; then
        echo -e "${GREEN}✅ PostgreSQL Container${NC}"
        POSTGRES_OK=1
    else
        echo -e "${RED}❌ PostgreSQL Container${NC}"
        POSTGRES_OK=0
    fi
    
    # Check N8N
    N8N_STATUS=$(docker-compose ps n8n --status running -q 2>/dev/null)
    if [ -n "$N8N_STATUS" ]; then
        echo -e "${GREEN}✅ N8N Container${NC}"
        N8N_OK=1
    else
        echo -e "${RED}❌ N8N Container${NC}"
        N8N_OK=0
    fi
fi

echo ""
echo "🌐 Network Connectivity"
echo "------------------------"

# Check N8N HTTP endpoint
if curl -s -f -o /dev/null http://localhost:5678; then
    echo -e "${GREEN}✅ N8N Web Interface (http://localhost:5678)${NC}"
    HTTP_OK=1
else
    echo -e "${RED}❌ N8N Web Interface${NC}"
    HTTP_OK=0
fi

echo ""
echo "💾 Storage & Resources"
echo "----------------------"

# Check disk space
DISK_USAGE=$(df -h "$PROJECT_DIR" | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -lt 90 ]; then
    echo -e "${GREEN}✅ Disk Space: ${DISK_USAGE}% used${NC}"
    DISK_OK=1
else
    echo -e "${RED}❌ Disk Space: ${DISK_USAGE}% used (Critical!)${NC}"
    DISK_OK=0
fi

# Check Docker volumes
if [ $DOCKER_OK -eq 1 ]; then
    N8N_VOLUME=$(docker volume ls -q | grep -c "obxflow_n8n_data" || true)
    PG_VOLUME=$(docker volume ls -q | grep -c "obxflow_postgres_data" || true)
    
    if [ $N8N_VOLUME -gt 0 ] && [ $PG_VOLUME -gt 0 ]; then
        echo -e "${GREEN}✅ Docker Volumes${NC}"
        VOLUMES_OK=1
    else
        echo -e "${YELLOW}⚠️  Docker Volumes (may need initialization)${NC}"
        VOLUMES_OK=0
    fi
fi

echo ""
echo "📊 Overall Status"
echo "-----------------"

# Calculate overall health
TOTAL_CHECKS=7
PASSED_CHECKS=$((DOCKER_OK + POSTGRES_OK + N8N_OK + HTTP_OK + DISK_OK + VOLUMES_OK))
HEALTH_PERCENTAGE=$((PASSED_CHECKS * 100 / TOTAL_CHECKS))

if [ $HEALTH_PERCENTAGE -eq 100 ]; then
    echo -e "${GREEN}🎉 All Systems Operational ($PASSED_CHECKS/$TOTAL_CHECKS)${NC}"
    OVERALL_STATUS="HEALTHY"
elif [ $HEALTH_PERCENTAGE -ge 70 ]; then
    echo -e "${YELLOW}⚠️  Partially Operational ($PASSED_CHECKS/$TOTAL_CHECKS)${NC}"
    OVERALL_STATUS="DEGRADED"
else
    echo -e "${RED}🚨 Critical Issues ($PASSED_CHECKS/$TOTAL_CHECKS)${NC}"
    OVERALL_STATUS="CRITICAL"
fi

echo ""
echo "💡 Quick Actions"
echo "----------------"

if [ $DOCKER_OK -eq 0 ]; then
    echo "• Start Docker Desktop"
fi

if [ $POSTGRES_OK -eq 0 ] || [ $N8N_OK -eq 0 ]; then
    echo "• Run: cd $PROJECT_DIR/n8n && docker-compose up -d"
fi

if [ $HTTP_OK -eq 0 ] && [ $N8N_OK -eq 1 ]; then
    echo "• Wait a moment for N8N to start, then check: http://localhost:5678"
fi

if [ $DISK_OK -eq 0 ]; then
    echo "• Free up disk space immediately!"
fi

echo ""
echo "📝 Log Entry"
echo "------------"
LOG_ENTRY="$TIMESTAMP | Status: $OVERALL_STATUS | Health: $HEALTH_PERCENTAGE% | Docker:$DOCKER_OK PG:$POSTGRES_OK N8N:$N8N_OK HTTP:$HTTP_OK Disk:$DISK_OK"
echo "$LOG_ENTRY" >> "$HEALTH_LOG"
echo "Logged to: $HEALTH_LOG"

echo ""
echo "🔗 Quick Links"
echo "--------------"
echo "• N8N Interface: http://localhost:5678"
echo "• Project Directory: $PROJECT_DIR"
echo "• Health Log: $HEALTH_LOG"

# Exit with status code based on health
if [ "$OVERALL_STATUS" = "HEALTHY" ]; then
    exit 0
elif [ "$OVERALL_STATUS" = "DEGRADED" ]; then
    exit 1
else
    exit 2
fi
