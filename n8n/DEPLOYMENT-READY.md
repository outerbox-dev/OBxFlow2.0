# 🚀 OBxFlow Deployment Guide

**Status:** Configuration Complete - Ready for Manual Docker Start

---

## ✅ What's Been Automated

1. **Environment Configuration**
   - ✅ `.env` file created from template
   - ✅ Secure encryption key generated
   - ✅ Strong database password generated  
   - ✅ Strong admin password generated
   - ✅ All credentials configured in `.env`

2. **Credentials Saved**
   - ✅ Saved to `CREDENTIALS.txt`
   - ⚠️  **SAVE TO PASSWORD MANAGER IMMEDIATELY**
   - ⚠️  **DELETE CREDENTIALS.txt AFTER SAVING**

---

## 🔑 Your Credentials

**N8N Access:** http://localhost:5678

```
Username: admin
Password: M03pMzxZ7CrycJAMFleY2I4pIQhCo7My
```

**Database:**
```
User: n8n_user
Password: BfZlN5fomPxk8YTmmGq7ZSBbni0Qt3tI
```

**Encryption Key:**
```
4e433577495d2909a0e1afd674f8d57245519f98916d6d08d8b8fb56c2081255
```

---

## 🐳 Start Docker Services

### Quick Start (Recommended)

Open a **new terminal** and run:

```bash
cd ~/Projects/OBxFlow2.0/n8n
docker-compose up -d
```

### Monitor Startup

```bash
# Watch logs in real-time
docker-compose logs -f

# Check service status
docker-compose ps

# Test N8N health
curl http://localhost:5678/healthz
```

### Expected Output

```
Creating network "n8n_obxflow-network" ... done
Creating volume "n8n_postgres_data" ... done
Creating volume "n8n_n8n_data" ... done
Creating obxflow-postgres ... done
Creating obxflow-n8n      ... done
```

---

## ⏱️ Startup Timeline

1. **0-10 seconds:** PostgreSQL initializing
2. **10-20 seconds:** N8N connecting to database
3. **20-30 seconds:** N8N fully ready
4. **30 seconds:** Access http://localhost:5678

---

## 🎯 First Login Steps

1. **Open Browser**
   ```
   open http://localhost:5678
   ```

2. **Login**
   - Username: `admin`
   - Password: `M03pMzxZ7CrycJAMFleY2I4pIQhCo7My`

3. **Verify**
   - Dashboard loads
   - Can create new workflow
   - All features accessible

---

## 🔍 Verification Checklist

After starting, verify:

```bash
# Services running
docker-compose ps
# Should show: obxflow-postgres (healthy), obxflow-n8n (healthy)

# PostgreSQL accessible
docker-compose exec postgres pg_isready -U n8n_user
# Should show: accepting connections

# N8N accessible
curl -I http://localhost:5678
# Should show: HTTP/1.1 200 OK

# Logs clean
docker-compose logs --tail=50
# Should show: no errors
```

---

## 🛠️ Common Commands

```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# Restart services
docker-compose restart

# View logs (all services)
docker-compose logs -f

# View logs (N8N only)
docker-compose logs -f n8n

# View logs (PostgreSQL only)
docker-compose logs -f postgres

# Check status
docker-compose ps

# Execute command in N8N
docker-compose exec n8n n8n --version
```

---

## 💾 Create Your First Backup

After verifying everything works:

```bash
cd ~/Projects/OBxFlow2.0/n8n
./scripts/backup.sh initial-backup
```

This creates: `backups/initial-backup.tar.gz`

---

## 🎨 Apply Branding (Next Phase)

After confirming N8N works:

1. **Review Branding Guide**
   ```bash
   cat custom/branding/README.md
   ```

2. **Add OuterBox Logos**
   - Place SVG logos in `custom/branding/logos/`
   - Logo files from brand standards document

3. **Create Custom CSS**
   - Create `custom/branding/css/outerbox-theme.css`
   - Use colors from branding guide

4. **Restart N8N**
   ```bash
   docker-compose restart n8n
   ```

---

## 🔗 Connect Integrations

### Slack Integration

1. Create Slack App at https://api.slack.com/apps
2. Get Bot Token (starts with `xoxb-`)
3. Add to N8N credentials
4. Test with simple workflow

### Google Workspace

1. Create OAuth credentials in Google Cloud Console
2. Add Client ID and Secret to N8N
3. Authorize access
4. Test Gmail/Drive access

### Other Services

See `.ai/05-CREDENTIALS.md` for complete list of needed API keys

---

## 🚨 Troubleshooting

### Port Already in Use

```bash
# Find what's using port 5678
lsof -i :5678

# Kill process if needed
kill -9 <PID>

# Or change port in .env
# N8N_PORT=5679
```

### Database Won't Start

```bash
# Check logs
docker-compose logs postgres

# Remove and recreate volume
docker-compose down
docker volume rm n8n_postgres_data
docker-compose up -d
```

### N8N Won't Connect

```bash
# Verify database is healthy
docker-compose ps postgres

# Check N8N logs
docker-compose logs n8n | grep -i error

# Restart N8N
docker-compose restart n8n
```

---

## 📊 Monitor Performance

### Check Resource Usage

```bash
# Docker stats
docker stats

# Disk usage
du -sh data/ logs/ backups/

# Database size
docker-compose exec postgres psql -U n8n_user -d n8n -c \
  "SELECT pg_size_pretty(pg_database_size('n8n'));"
```

---

## 🔒 Security Reminders

- ✅ Credentials saved in password manager
- ✅ CREDENTIALS.txt deleted after saving
- ✅ .env file never committed (in .gitignore)
- ✅ Strong passwords used
- ✅ Encryption key secured
- 🔄 Plan to enable HTTPS in production
- 🔄 Plan to implement SSO

---

## 📈 Next Steps Priority

1. **Immediate:**
   - [ ] Start Docker services
   - [ ] Login to N8N
   - [ ] Save credentials to password manager
   - [ ] Delete CREDENTIALS.txt
   - [ ] Create initial backup

2. **This Week:**
   - [ ] Apply OuterBox branding
   - [ ] Create first test workflow
   - [ ] Connect Slack integration
   - [ ] Set up Google Workspace
   - [ ] Train team on basics

3. **This Month:**
   - [ ] Build workflow library
   - [ ] Document common patterns
   - [ ] Set up monitoring
   - [ ] Plan production migration
   - [ ] Security review

---

## 🎉 Success Indicators

You'll know setup is successful when:

1. ✅ http://localhost:5678 loads
2. ✅ Can login with admin credentials
3. ✅ Can create and save a workflow
4. ✅ Can execute a simple workflow
5. ✅ Logs show no errors
6. ✅ All health checks passing

---

## 📞 Support Resources

- **Project Docs:** `n8n/README.md`
- **Quick Start:** `docs/setup/QUICKSTART.md`
- **Branding:** `n8n/custom/branding/README.md`
- **N8N Docs:** https://docs.n8n.io/
- **Community:** https://community.n8n.io/

---

**Ready to deploy! Open a terminal and run `docker-compose up -d` 🚀**
