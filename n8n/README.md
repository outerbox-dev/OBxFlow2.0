# N8N Setup Guide

**OBxFlow2.0 - OuterBox Internal Automation Platform**

---

## 🚀 Quick Start

### Prerequisites

Before starting, ensure you have installed:

- **Docker Desktop** (24.x or later)
- **Docker Compose** (2.x or later)
- **Git** (for version control)
- **openssl** (for generating encryption keys)

### Setup Steps

#### 1. Clone Repository (if not already done)

```bash
git clone https://github.com/outerbox-dev/OBxFlow2.0.git
cd OBxFlow2.0/n8n
```

#### 2. Configure Environment

```bash
# Copy environment template
cp .env.example .env

# Generate encryption key
openssl rand -hex 32

# Edit .env and add your encryption key
nano .env
```

**Required Changes in .env:**

```bash
# Set strong admin password
N8N_BASIC_AUTH_PASSWORD=YourStrongPasswordHere

# Add generated encryption key
N8N_ENCRYPTION_KEY=your_generated_key_here

# Set secure database password
DB_POSTGRESDB_PASSWORD=YourSecureDBPasswordHere
POSTGRES_PASSWORD=YourSecureDBPasswordHere
```

#### 3. Start Services

```bash
# Start in detached mode
docker-compose up -d

# View logs
docker-compose logs -f

# Check status
docker-compose ps
```

#### 4. Access N8N

Open your browser and navigate to:
```
http://localhost:5678
```

Login with credentials from your `.env` file:
- **Username:** admin (or what you set in N8N_BASIC_AUTH_USER)
- **Password:** Your N8N_BASIC_AUTH_PASSWORD

---

## 🏗️ Project Structure

```
n8n/
├── docker-compose.yml      # Docker services configuration
├── .env.example            # Environment template
├── .env                    # Your configuration (gitignored)
├── README.md               # This file
├── custom/
│   ├── branding/           # OuterBox brand assets
│   │   ├── logos/
│   │   ├── css/
│   │   └── images/
│   └── nodes/              # Custom N8N nodes
├── backups/                # Database backups
├── logs/                   # Application logs
├── data/                   # N8N data (gitignored)
└── scripts/                # Helper scripts
```

---

## 🔧 Common Operations

### Stop Services

```bash
docker-compose down
```

### Restart Services

```bash
docker-compose restart
```

### View Logs

```bash
# All services
docker-compose logs -f

# N8N only
docker-compose logs -f n8n

# PostgreSQL only
docker-compose logs -f postgres
```

### Update N8N

```bash
# Pull latest image
docker-compose pull

# Recreate containers
docker-compose up -d
```

---

## 💾 Backup & Restore

### Create Backup

```bash
# Backup database
docker-compose exec postgres pg_dump -U n8n_user n8n > backups/backup_$(date +%Y%m%d_%H%M%S).sql

# Backup workflows (optional - already in database)
docker-compose exec n8n n8n export:workflow --all --output=/home/node/.n8n/backups/
```

### Restore from Backup

```bash
# Stop services
docker-compose down

# Remove old data
docker volume rm n8n_postgres_data

# Start services
docker-compose up -d

# Wait for postgres to be ready
sleep 10

# Restore database
docker-compose exec -T postgres psql -U n8n_user -d n8n < backups/your_backup.sql
```

---

## 🔒 Security Best Practices

### 1. Strong Passwords

- Use passwords with 16+ characters
- Mix uppercase, lowercase, numbers, symbols
- Never reuse passwords
- Use a password manager

### 2. Encryption Key

```bash
# Generate secure key
openssl rand -hex 32

# NEVER share or commit this key
# Store securely (password manager)
```

### 3. Database Security

- Change default database password
- Use strong postgres password
- Keep database internal (not exposed)

### 4. Network Security

- Use HTTPS in production
- Configure firewall rules
- Limit port access
- Use VPN if needed

### 5. Access Control

- Use strong authentication
- Implement SSO in production
- Regular password rotation
- Audit access logs

---

## 🎨 Branding Customization

### Apply OuterBox Theme

1. **Add Custom CSS**

```bash
# Create custom theme file
nano custom/branding/css/outerbox-theme.css
```

2. **Add Logos**

```bash
# Copy OuterBox logos
cp /path/to/logo-dark.svg custom/branding/logos/
cp /path/to/logo-white.svg custom/branding/logos/
```

3. **Configure N8N**

Update `.env` to point to custom branding:
```bash
N8N_CUSTOM_EXTENSIONS=/home/node/.n8n/custom
```

4. **Restart N8N**

```bash
docker-compose restart n8n
```

See `custom/branding/README.md` for detailed branding guide.

---

## 🐛 Troubleshooting

### Issue: Cannot Connect to N8N

**Symptoms:** Browser can't reach http://localhost:5678

**Solutions:**
```bash
# Check if containers are running
docker-compose ps

# Check logs for errors
docker-compose logs n8n

# Verify port not in use
lsof -i :5678

# Restart services
docker-compose restart
```

### Issue: Database Connection Failed

**Symptoms:** N8N shows database connection error

**Solutions:**
```bash
# Check postgres is healthy
docker-compose ps postgres

# View postgres logs
docker-compose logs postgres

# Verify credentials in .env match

# Restart database
docker-compose restart postgres
```

### Issue: Workflows Not Saving

**Symptoms:** Changes to workflows don't persist

**Solutions:**
```bash
# Check database connection
docker-compose logs n8n | grep -i database

# Verify encryption key set
grep N8N_ENCRYPTION_KEY .env

# Check disk space
df -h

# Restart N8N
docker-compose restart n8n
```

### Issue: Permission Denied

**Symptoms:** Docker permission errors

**Solutions:**
```bash
# Add user to docker group (Linux)
sudo usermod -aG docker $USER

# Restart Docker Desktop (Mac/Windows)

# Check volume permissions
ls -la data/ logs/
```

---

## 📊 Monitoring

### Health Checks

```bash
# Check service health
docker-compose ps

# N8N health endpoint
curl http://localhost:5678/healthz

# Database connection test
docker-compose exec postgres pg_isready
```

### Performance

```bash
# View resource usage
docker stats

# Check disk usage
du -sh data/ logs/ backups/

# Database size
docker-compose exec postgres psql -U n8n_user -d n8n -c "SELECT pg_size_pretty(pg_database_size('n8n'));"
```

---

## 🔄 Upgrade Path

### Minor Updates

```bash
# Pull latest stable
docker-compose pull n8n

# Recreate container
docker-compose up -d n8n
```

### Major Updates

1. **Backup everything** (database + workflows)
2. **Review changelog** for breaking changes
3. **Test in development** environment first
4. **Update in production** during maintenance window
5. **Verify all workflows** work correctly

---

## 📚 Additional Resources

- [N8N Documentation](https://docs.n8n.io/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [OuterBox Brand Standards](../branding/)
- [Project Wiki](../../docs/)

---

## 🆘 Getting Help

### Internal Support

- Check `docs/` directory for guides
- Review `.ai/` for AI development context
- Contact DevOps team for infrastructure issues

### External Resources

- [N8N Community Forum](https://community.n8n.io/)
- [N8N Discord](https://discord.gg/n8n)
- [Docker Community](https://forums.docker.com/)

---

## ✅ Post-Installation Checklist

After installation, verify:

- [ ] N8N accessible at http://localhost:5678
- [ ] Can login with credentials
- [ ] Database connection working
- [ ] Can create and save workflow
- [ ] Webhooks functional
- [ ] Logs being written
- [ ] Backups directory accessible
- [ ] Custom branding directory mounted
- [ ] Health checks passing
- [ ] All environment variables set

---

**Version:** 1.0  
**Last Updated:** November 15, 2025  
**Maintained By:** OuterBox DevOps Team
