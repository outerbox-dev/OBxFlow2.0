# OBxFlow 2.0 - Deployment Checklist

**Date:** November 15, 2025  
**Purpose:** Step-by-step checklist for complete OBxFlow deployment

---

## ✅ Phase 1: Infrastructure (COMPLETED)

- [x] Docker Desktop installed and running
- [x] tmux session created (`obxflow-setup`)
- [x] Project directory created at `~/Projects/OBxFlow2.0`
- [x] Git repository initialized
- [x] Docker Compose configuration created
- [x] PostgreSQL database container deployed
- [x] N8N application container deployed
- [x] Both containers running and healthy
- [x] N8N accessible at http://localhost:5678
- [x] Custom branding CSS created
- [x] Launch script created

---

## 🔄 Phase 2: GitHub Integration (IN PROGRESS)

- [x] Git repository connected to GitHub remote
- [x] Initial commits created
- [ ] **GitHub authentication configured** ⚠️ **BLOCKER**
- [ ] Code pushed to remote repository
- [ ] Repository visible at https://github.com/outerbox-dev/OBxFlow2.0

### **Action Required:** Set up GitHub Authentication

**Option A: SSH Key (Recommended)**
```bash
# Check for existing SSH key
ls -la ~/.ssh/id_*.pub

# If none exists, create one
ssh-keygen -t ed25519 -C "your_email@outerbox.com"

# Copy public key
cat ~/.ssh/id_ed25519.pub | pbcopy

# Add to GitHub: Settings → SSH and GPG keys → New SSH key

# Update git remote to use SSH
cd ~/Projects/OBxFlow2.0
git remote set-url origin git@github.com:outerbox-dev/OBxFlow2.0.git

# Test connection
ssh -T git@github.com

# Push code
git push origin main
```

**Option B: Personal Access Token**
```bash
# Create token: GitHub → Settings → Developer settings → Personal access tokens → Generate new token
# Scopes needed: repo (all)

# Configure git credential helper
git config --global credential.helper osxkeychain

# Push (will prompt for username and token)
cd ~/Projects/OBxFlow2.0
git push origin main
# Username: your-github-username
# Password: ghp_your_personal_access_token
```

---

## 🎨 Phase 3: N8N Initial Setup (MANUAL REQUIRED)

- [ ] Access N8N at http://localhost:5678
- [ ] Complete setup wizard
  - [ ] Create owner account
  - [ ] Set workspace name: "OBxFlow"
  - [ ] Configure basic settings
- [ ] Apply custom branding
  - [ ] Upload OuterBox logo (white version)
  - [ ] Upload favicon
  - [ ] Enable custom CSS styling
  - [ ] Verify brand colors applied
- [ ] Configure workspace settings
  - [ ] Set timezone: America/New_York
  - [ ] Set date format
  - [ ] Configure user permissions

### **Credentials for Initial Login**
- **URL:** http://localhost:5678
- **Username:** admin
- **Password:** [See .env file or STATUS_REPORT.md]

---

## 🔌 Phase 4: Slack Integration

- [ ] Create Slack App
  - [ ] Go to https://api.slack.com/apps
  - [ ] Click "Create New App" → "From scratch"
  - [ ] Name: "OBxFlow Bot"
  - [ ] Workspace: OuterBox
- [ ] Configure Bot Permissions
  - [ ] Navigate to "OAuth & Permissions"
  - [ ] Add Bot Token Scopes:
    - `chat:write` - Send messages
    - `chat:write.public` - Send messages to public channels
    - `channels:read` - View basic channel info
    - `channels:history` - View channel messages
    - `users:read` - View users
    - `users:read.email` - View email addresses
    - `files:write` - Upload files
    - `groups:read` - View private channels (if needed)
- [ ] Install App to Workspace
  - [ ] Click "Install to Workspace"
  - [ ] Authorize the app
  - [ ] Copy "Bot User OAuth Token" (starts with `xoxb-`)
- [ ] Configure Event Subscriptions (optional)
  - [ ] Enable Events
  - [ ] Set Request URL: `http://your-n8n-url/webhook/slack`
  - [ ] Subscribe to bot events as needed
- [ ] Add to N8N
  - [ ] N8N → Credentials → New Credential
  - [ ] Select "Slack OAuth2 API"
  - [ ] Paste Bot Token
  - [ ] Test connection
- [ ] Create test workflow
  - [ ] Simple "Send message to #general"
  - [ ] Execute and verify

---

## 🔐 Phase 5: Google Workspace Integration

- [ ] Set up Google Cloud Project
  - [ ] Go to https://console.cloud.google.com
  - [ ] Create new project: "OBxFlow"
  - [ ] Enable required APIs:
    - [ ] Gmail API
    - [ ] Google Drive API
    - [ ] Google Calendar API
    - [ ] Google Sheets API (optional)
- [ ] Configure OAuth Consent Screen
  - [ ] User Type: Internal (for workspace users)
  - [ ] App name: "OBxFlow"
  - [ ] Support email: your-email@outerbox.com
  - [ ] Scopes: Add Gmail, Drive, Calendar scopes
- [ ] Create OAuth 2.0 Credentials
  - [ ] Credentials → Create Credentials → OAuth 2.0 Client ID
  - [ ] Application type: Web application
  - [ ] Name: "N8N OBxFlow"
  - [ ] Authorized redirect URIs:
    - `http://localhost:5678/rest/oauth2-credential/callback`
  - [ ] Copy Client ID and Client Secret
- [ ] Add to N8N
  - [ ] For each service (Gmail, Drive, Calendar):
    - [ ] N8N → Credentials → New Credential
    - [ ] Select service OAuth2 API
    - [ ] Paste Client ID and Client Secret
    - [ ] Complete OAuth flow
    - [ ] Test connection
- [ ] Test each integration
  - [ ] Gmail: Send test email
  - [ ] Drive: List files
  - [ ] Calendar: List events

---

## 📧 Phase 6: Email Configuration (Optional)

- [ ] Configure SMTP for N8N
  - [ ] Settings → Email
  - [ ] SMTP Host: smtp.gmail.com (or OuterBox SMTP)
  - [ ] SMTP Port: 587
  - [ ] From Email: obxflow@outerbox.com
  - [ ] Username/Password
- [ ] Test email sending
  - [ ] Send test notification
  - [ ] Verify delivery

---

## 🔄 Phase 7: Core Workflows

### Workflow 1: Daily Standup Reminder
- [ ] Create new workflow
- [ ] Trigger: Schedule (weekdays 8:45 AM EST)
- [ ] Action: Send Slack message to #general
- [ ] Message: "🌅 Good morning team! Daily standup in 15 minutes!"
- [ ] Test and activate

### Workflow 2: Welcome New Team Member
- [ ] Create new workflow
- [ ] Trigger: Manual button (for demo)
- [ ] Actions:
  - [ ] Send welcome message to #general
  - [ ] Create Google Drive folder
  - [ ] Add calendar event
  - [ ] Send welcome email
- [ ] Test and activate

### Workflow 3: Birthday Announcements
- [ ] Create new workflow
- [ ] Trigger: Schedule (daily 9:00 AM EST)
- [ ] Data source: Google Sheets or database
- [ ] Action: If birthday today, post to #general
- [ ] Test and activate

### Workflow 4: Lead Notification
- [ ] Create new workflow
- [ ] Trigger: Webhook (from website form)
- [ ] Actions:
  - [ ] Parse lead data
  - [ ] Send Slack notification to #sales
  - [ ] Log to Google Sheets
  - [ ] Send confirmation email
- [ ] Test and activate

### Workflow 5: Weekly Report Generator
- [ ] Create new workflow
- [ ] Trigger: Schedule (Fridays 4:00 PM EST)
- [ ] Actions:
  - [ ] Aggregate data from multiple sources
  - [ ] Generate summary
  - [ ] Send email to stakeholders
- [ ] Test and activate

---

## 📚 Phase 8: Documentation

- [x] Create deployment checklist (this file)
- [ ] Create user guide
- [ ] Create integration setup guide
- [ ] Create troubleshooting guide
- [ ] Create workflow templates
- [ ] Record demo video
- [ ] Create training materials

---

## 🎓 Phase 9: Team Training

- [ ] Schedule training session
  - [ ] Date/Time: TBD
  - [ ] Duration: 30-45 minutes
  - [ ] Attendees: All team members
- [ ] Prepare training agenda
  - [ ] What is OBxFlow
  - [ ] How to access
  - [ ] Demo of existing workflows
  - [ ] How to create simple workflows
  - [ ] Where to get help
- [ ] Conduct training
- [ ] Gather feedback
- [ ] Create #obxflow-support channel in Slack

---

## 🔍 Phase 10: Monitoring & Maintenance

- [ ] Set up monitoring
  - [ ] Docker container health checks
  - [ ] Database backup script
  - [ ] Disk space monitoring
  - [ ] Workflow execution monitoring
- [ ] Configure backups
  - [ ] Daily database backup
  - [ ] Weekly workflow export
  - [ ] Backup to Google Drive
- [ ] Create maintenance schedule
  - [ ] Weekly: Review failed executions
  - [ ] Monthly: Update N8N version
  - [ ] Quarterly: Review and optimize workflows
- [ ] Document troubleshooting procedures

---

## 📊 Success Metrics

Track these metrics to measure success:

- [ ] **Adoption Rate**
  - Target: 80% of team with accounts in 30 days
  - Current: 0%

- [ ] **Active Workflows**
  - Target: 10+ workflows in 60 days
  - Current: 0

- [ ] **Executions**
  - Target: 50+ executions/day in 60 days
  - Current: 0

- [ ] **Time Saved**
  - Target: 20+ hours/week in 90 days
  - Current: 0

- [ ] **User Satisfaction**
  - Target: 8/10 average rating
  - Current: N/A

---

## ⚠️ Known Issues & Blockers

### Current Blockers:
1. **GitHub Authentication Not Set Up**
   - Impact: Cannot push code to remote repository
   - Priority: High
   - Action: Set up SSH key or personal access token

2. **Missing Logo Files**
   - Impact: Cannot complete branding
   - Priority: Medium
   - Action: Request logo files from marketing team

3. **Slack App Not Created**
   - Impact: Cannot test Slack integration
   - Priority: High
   - Action: Create Slack app with workspace admin

4. **Google OAuth Not Configured**
   - Impact: Cannot integrate Google Workspace
   - Priority: High
   - Action: Set up Google Cloud project and OAuth

### Resolved Issues:
- ✅ Docker containers running successfully
- ✅ Database connectivity working
- ✅ N8N accessible on localhost

---

## 🚀 Quick Commands Reference

### Docker Management
```bash
# Start services
cd ~/Projects/OBxFlow2.0/n8n && docker-compose up -d

# Stop services
cd ~/Projects/OBxFlow2.0/n8n && docker-compose stop

# Restart services
cd ~/Projects/OBxFlow2.0/n8n && docker-compose restart

# View logs
cd ~/Projects/OBxFlow2.0/n8n && docker-compose logs -f

# Check status
cd ~/Projects/OBxFlow2.0/n8n && docker-compose ps

# Stop and remove
cd ~/Projects/OBxFlow2.0/n8n && docker-compose down
```

### tmux Management
```bash
# Attach to session
tmux attach -t obxflow-setup

# List sessions
tmux ls

# Create new window
# (inside tmux) Ctrl+b c

# Switch windows
# (inside tmux) Ctrl+b n (next) or Ctrl+b p (previous)

# Detach from session
# (inside tmux) Ctrl+b d
```

### Git Operations
```bash
# Check status
cd ~/Projects/OBxFlow2.0 && git status

# Add files
cd ~/Projects/OBxFlow2.0 && git add .

# Commit changes
cd ~/Projects/OBxFlow2.0 && git commit -m "description"

# Push to GitHub (after auth setup)
cd ~/Projects/OBxFlow2.0 && git push origin main

# View commit history
cd ~/Projects/OBxFlow2.0 && git log --oneline -10
```

### N8N Access
```bash
# Quick launch with browser
~/Projects/OBxFlow2.0/launch.sh

# Direct URL
open http://localhost:5678
```

---

## 📝 Notes

- All sensitive credentials stored in `.env` files (gitignored)
- Custom branding CSS at `/n8n/custom/branding/custom.css`
- Database data persists in Docker volume `obxflow_n8n_data`
- Workflow data stored in PostgreSQL database
- Regular backups recommended before major changes

---

**Last Updated:** November 15, 2025  
**Version:** 1.0  
**Status:** Living document - update as deployment progresses
