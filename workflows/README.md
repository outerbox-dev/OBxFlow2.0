# Workflow Templates

Pre-built workflow templates ready to import into OBxFlow.

---

## 📦 Available Templates

### 1. Daily Standup Reminder
**File:** `daily-standup-reminder.json`  
**Purpose:** Sends automated reminder for daily standup meetings

**Trigger:** Schedule (weekdays at 8:45 AM EST)  
**Actions:**
- Sends Slack message to #general channel
- Includes standup talking points

**Configuration Needed:**
- Slack credential
- Adjust time if needed
- Change channel if needed

---

### 2. Welcome New Team Member
**File:** `welcome-new-team-member.json`  
**Purpose:** Automates onboarding for new team members

**Trigger:** Manual button (run when someone starts)  
**Actions:**
- Announces new team member in Slack #general
- Creates personalized Google Drive folder
- Schedules welcome meeting in Google Calendar
- Sends welcome email via Gmail

**Configuration Needed:**
- Slack credential
- Google Drive credential
- Google Calendar credential
- Gmail credential
- Update new member details in "Set New Member Info" node

**How to Use:**
1. Open workflow
2. Edit "Set New Member Info" node
3. Update: name, email, start date, department, manager
4. Click "Execute Workflow"

---

## 📥 Importing Templates

### Method 1: Import via N8N UI

1. **Download Template**
   - Navigate to `~/Projects/OBxFlow2.0/workflows/templates/`
   - Copy the JSON file you want

2. **Import in N8N**
   - Open N8N (http://localhost:5678)
   - Click "Workflows" in sidebar
   - Click "+" to create new workflow
   - Click the "..." menu (top right)
   - Select "Import from File"
   - Paste the JSON content
   - Click "Import"

3. **Configure Credentials**
   - Each node with a credential will show a warning
   - Click on each node
   - Select or create the required credential
   - Test the connection

4. **Test the Workflow**
   - Click "Execute Workflow" to test
   - Check each step executes successfully
   - Fix any errors

5. **Activate**
   - Toggle "Active" switch (top right)
   - Workflow is now live!

### Method 2: Import via CLI

```bash
# Copy template to N8N directory
cp ~/Projects/OBxFlow2.0/workflows/templates/daily-standup-reminder.json \
   ~/Projects/OBxFlow2.0/n8n/workflows/

# Restart N8N to pick up new workflow
cd ~/Projects/OBxFlow2.0/n8n
docker-compose restart n8n
```

---

## ✏️ Customizing Templates

### Changing the Schedule

For workflows with Schedule Triggers:

1. **Open the workflow**
2. **Click on "Schedule Trigger" node**
3. **Modify settings:**
   - **Mode:** Every day, Every week, Cron expression
   - **Hour:** 0-23
   - **Minute:** 0-59
4. **Save the workflow**

**Example Schedules:**
- Every weekday at 9 AM: Mode="Every day", Hour=9, Minute=0, Weekdays only
- Every Monday at 2 PM: Mode="Every week", Day=Monday, Hour=14, Minute=0
- Custom: Use Cron expression (e.g., `0 30 8 * * 1-5` = weekdays 8:30 AM)

### Changing Slack Channels

1. **Open the workflow**
2. **Click on any Slack node**
3. **Change "Channel" parameter**
   - Use channel name: `#general`, `#marketing`
   - Use channel ID: `C1234567890`
   - Use user ID for DM: `U1234567890`

### Changing Message Content

1. **Click on Slack/Email node**
2. **Edit "Text" or "Message" parameter**
3. **Use expressions for dynamic content:**
   - `{{$json.fieldName}}` - Insert data from previous node
   - `{{$now}}` - Current timestamp
   - `{{$today}}` - Today's date

**Example:**
```
Good morning, {{$json.userName}}!

Your tasks for {{$today}}:
• {{$json.task1}}
• {{$json.task2}}
```

---

## 🎨 Creating Your Own Templates

### Best Practices

**1. Use Clear Node Names**
```
❌ Bad: "Slack", "Slack 1", "HTTP Request"
✅ Good: "Slack - Send Welcome", "Slack - Notify Team", "API - Get User Data"
```

**2. Add Node Notes**
- Right-click node → Edit note
- Explain what the node does
- Add configuration hints

**3. Use Set Nodes for Configuration**
- Put configurable values in "Set" nodes at the start
- Makes it easy to customize without editing multiple nodes

**4. Handle Errors**
- Add error handling branches
- Use "IF" nodes to check for errors
- Send notifications on failures

**5. Test Thoroughly**
- Test with real data
- Test error cases
- Test edge cases

### Template Checklist

Before sharing a workflow template:

- [ ] Clear, descriptive workflow name
- [ ] All nodes have descriptive names
- [ ] Important nodes have notes
- [ ] Configuration values in Set node (not hardcoded)
- [ ] Tested and working
- [ ] Credentials are NOT embedded
- [ ] Documentation written
- [ ] Tagged appropriately

### Exporting Your Template

1. **Open your workflow**
2. **Click "..." menu** (top right)
3. **Select "Download"**
4. **Save to templates folder:**
   ```bash
   mv ~/Downloads/My-Workflow.json \
      ~/Projects/OBxFlow2.0/workflows/templates/my-workflow.json
   ```
5. **Document it** (add to this README)
6. **Commit to git**

---

## 🏷️ Workflow Categories

Organize workflows by tagging them:

- **`reminder`** - Scheduled reminders
- **`onboarding`** - New hire workflows
- **`notification`** - Alert and notification workflows
- **`report`** - Report generation
- **`integration`** - Service-to-service integrations
- **`automation`** - General automation
- **`team`** - Team-wide workflows
- **`marketing`** - Marketing-specific
- **`sales`** - Sales-specific
- **`hr`** - Human resources

**To add tags in N8N:**
1. Open workflow settings
2. Add tags
3. Save

---

## 🐛 Troubleshooting Templates

### "Credential not found" Error

**Problem:** Template references credentials that don't exist

**Solution:**
1. Click on node with error
2. Under "Credentials" dropdown
3. Select existing credential or create new one
4. Save and test

### "Invalid JSON" Error on Import

**Problem:** JSON file is corrupted or incomplete

**Solution:**
1. Verify JSON is valid (use jsonlint.com)
2. Check for missing braces or brackets
3. Re-download template from repository

### Workflow Executes but Does Nothing

**Problem:** Credentials or configurations are wrong

**Solution:**
1. Click "Executions" to see details
2. Check each node's output
3. Verify credentials are working
4. Check if services are accessible

### "Node not found" Error

**Problem:** Template uses a node type not installed

**Solution:**
1. Go to Settings → Community Nodes
2. Search for required node
3. Install and restart N8N
4. Re-import template

---

## 📚 Additional Resources

### Learning Resources
- [N8N Official Docs](https://docs.n8n.io)
- [N8N Workflow Examples](https://n8n.io/workflows)
- [N8N Community Forum](https://community.n8n.io)

### Video Tutorials
- Creating Workflows (Coming Soon)
- Working with Credentials (Coming Soon)
- Advanced Workflow Patterns (Coming Soon)

### Getting Help
- Post in #obxflow-support on Slack
- Check [User Guide](../docs/USER_GUIDE.md)
- Review [Integration Setup](../docs/INTEGRATION_SETUP.md)

---

## 🎯 Template Requests

Have an idea for a useful workflow template?

1. Post in #obxflow-support
2. Describe the automation need
3. Include:
   - What triggers it
   - What it should do
   - Which services it needs
4. Vote on popular requests

---

## 📝 Contributing Templates

Want to share your workflow?

1. **Create and test** your workflow
2. **Export** as JSON
3. **Add to templates folder**
4. **Document** in this README
5. **Commit** to git
6. **Announce** in #obxflow-support

**Template Structure:**
```json
{
  "name": "Descriptive Name",
  "nodes": [...],
  "connections": {...},
  "active": false,
  "settings": {},
  "tags": [...]
}
```

---

**Happy Automating! 🚀**
