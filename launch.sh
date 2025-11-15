#!/bin/bash

# ==========================================
# OBxFlow Launch Script
# ==========================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Project directories
PROJECT_DIR="$HOME/Projects/OBxFlow2.0"
N8N_DIR="$PROJECT_DIR/n8n"

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}        OBxFlow - N8N Platform Launcher        ${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo -e "${RED}❌ Docker is not running!${NC}"
    echo -e "${YELLOW}Please start Docker Desktop and try again.${NC}"
    exit 1
fi

# Navigate to n8n directory
cd "$N8N_DIR"

# Check container status
STATUS=$(docker-compose ps -q)

if [ -z "$STATUS" ]; then
    echo -e "${YELLOW}🚀 Starting OBxFlow containers...${NC}"
    docker-compose up -d
    echo -e "${GREEN}✅ Containers started!${NC}"
else
    RUNNING=$(docker-compose ps --services --filter "status=running")
    if [ -z "$RUNNING" ]; then
        echo -e "${YELLOW}🔄 Restarting stopped containers...${NC}"
        docker-compose start
        echo -e "${GREEN}✅ Containers restarted!${NC}"
    else
        echo -e "${GREEN}✅ OBxFlow is already running!${NC}"
    fi
fi

# Wait for services to be healthy
echo -e "${YELLOW}⏳ Waiting for services to be healthy...${NC}"
sleep 5

# Check health status
if curl -s -o /dev/null -w "%{http_code}" http://localhost:5678/healthz | grep -q "200"; then
    echo -e "${GREEN}✅ N8N is healthy and running!${NC}"
else
    echo -e "${RED}⚠️  N8N health check failed. Checking logs...${NC}"
    docker-compose logs --tail=20 n8n
fi

echo ""
echo -e "${BLUE}================================================${NC}"
echo -e "${GREEN}🎉 OBxFlow is Ready!${NC}"
echo ""
echo -e "${BLUE}📍 Access Points:${NC}"
echo -e "   Web Interface: ${GREEN}http://localhost:5678${NC}"
echo -e "   Username: ${YELLOW}admin${NC}"
echo -e "   Password: ${YELLOW}[Check .env file]${NC}"
echo ""
echo -e "${BLUE}📊 Container Status:${NC}"
docker-compose ps
echo ""
echo -e "${BLUE}🛠️  Useful Commands:${NC}"
echo -e "   View logs:    ${YELLOW}docker-compose logs -f${NC}"
echo -e "   Stop:         ${YELLOW}docker-compose stop${NC}"
echo -e "   Restart:      ${YELLOW}docker-compose restart${NC}"
echo -e "   Full reset:   ${YELLOW}docker-compose down -v${NC}"
echo ""
echo -e "${BLUE}================================================${NC}"

# Open browser if on macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${YELLOW}🌐 Opening browser...${NC}"
    sleep 2
    open "http://localhost:5678"
fi
