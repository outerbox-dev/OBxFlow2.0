# OBxFlow User Guide

**Welcome to OBxFlow** - OuterBox's Internal Automation Platform  
**Version:** 1.0  
**Last Updated:** November 15, 2025

---

## 📖 Table of Contents

1. [What is OBxFlow?](#what-is-obxflow)
2. [Getting Started](#getting-started)
3. [Creating Your First Workflow](#creating-your-first-workflow)
4. [Using Existing Workflows](#using-existing-workflows)
5. [Common Integrations](#common-integrations)
6. [Tips & Best Practices](#tips--best-practices)
7. [Troubleshooting](#troubleshooting)
8. [Getting Help](#getting-help)

---

## 🎯 What is OBxFlow?

OBxFlow is OuterBox's custom automation platform built on N8N. It allows you to:

- **Automate repetitive tasks** - Let workflows handle routine work
- **Connect your tools** - Slack, Gmail, Google Drive, Calendar, and more
- **Build custom processes** - Create workflows tailored to your needs
- **Save time** - Focus on high-value work, not manual tasks

### Common Use Cases

**For Everyone:**
- Automated reminders and notifications
- File organization and backups
- Data collection and reporting
- Email automation

**For Teams:**
- New hire onboarding
- Client communication workflows
- Project status updates
- Team collaboration

**For Leaders:**
- Performance dashboards
- Report generation
- Approval workflows
- Analytics and insights

---

## 🚀 Getting Started

### Accessing OBxFlow

1. **Open your browser**
2. **Navigate to:** http://localhost:5678 *(or your organization's URL)*
3. **Login with your credentials:**
   - Username: Your email
   - Password: Provided by admin

### Your First Login

When you first log in, you'll see:

- **Dashboard** - Overview of recent workflows
- **Workflows** - List of all available workflows
- **Executions** - History of workflow runs
- **Credentials** - Your connected accounts

### Understanding the Interface

**Left Sidebar:**
- 🏠 **Dashboard** - Your home base
- ⚡ **Workflows** - View and create workflows
- 📊 **Executions** - See what's running
- 🔐 **Credentials** - Manage connections
- ⚙️ **Settings** - Your preferences

**Main Canvas:**
- This is where you'll build and view workflows
- Drag and drop nodes to create automations
- Connect nodes to define the flow

---

## 🛠️ Creating Your First Workflow

Let's create a simple workflow together: **Daily Reminder**

### Step 1: Create New Workflow

1. Click **"Workflows"** in the left sidebar
2. Click the **"+"** button (top right)
3. Name your workflow: **"My Daily Reminder"**
4. Click **"Save"**

### Step 2: Add a Trigger

Every workflow needs a trigger - what starts it?

1. Click **"Add node"** on the canvas
2. Select **"Schedule Trigger"**
3. Configure:
   - **Mode:** Every day
   - **Hour:** 9
   - **Minute:** 0
4. Click **"Execute node"** to test

### Step 3: Add an Action

Now let's add what happens:

1. Click the **"+"** on the trigger node
2. Select **"Slack"**
3. Choose operation: **"Send message"**
4. Select or add Slack credentials
5. Configure:
   - **Channel:** #general
   - **Text:** "Good morning! Don't forget to check OBxFlow today! 🚀"
6. Click **"Execute node"** to test

### Step 4: Activate Your Workflow

1. Toggle the **"Active"** switch (top right)
2. Your workflow is now live!
3. It will run every day at 9 AM

**Congratulations!** 🎉 You've created your first workflow!

---

## 🔄 Using Existing Workflows

### Finding Workflows

1. Go to **"Workflows"** in the sidebar
2. Use the search bar to find specific workflows
3. Click on any workflow to view details

### Running a Workflow Manually

Some workflows have manual triggers:

1. Open the workflow
2. Click **"Execute Workflow"** button
3. Watch it run in real-time
4. Check the results

### Understanding Workflow Status

- 🟢 **Green** - Workflow succeeded
- 🔴 **Red** - Workflow failed
- ⏸️ **Gray** - Workflow inactive
- ▶️ **Blue** - Workflow running

### Viewing Execution History

1. Click **"Executions"** in sidebar
2. See all recent workflow runs
3. Click any execution to see details
4. Debug failed executions

---

## 🔌 Common Integrations

### Slack Integration

**What you can do:**
- Send messages to channels
- Send direct messages
- Upload files
- Read messages
- Create channels
- Manage users

**Common workflows:**
- Team notifications
- Status updates
- Alert systems
- Bot interactions

**Example:**
```
Trigger: New form submission
Action: Send message to #leads with form data
```

### Gmail Integration

**What you can do:**
- Send emails
- Read emails
- Search emails
- Add labels
- Delete emails
- Get attachments

**Common workflows:**
- Automated responses
- Email forwarding
- Email organization
- Digest creation

**Example:**
```
Trigger: Receive email with subject "Urgent"
Action: Send Slack notification to #urgent-alerts
```

### Google Drive Integration

**What you can do:**
- Upload files
- Download files
- Create folders
- Share files
- Search files
- Move/copy files

**Common workflows:**
- Automated backups
- File organization
- Report generation
- Document sharing

**Example:**
```
Trigger: New file in "Reports" folder
Action: Share with team and notify in Slack
```

### Google Calendar Integration

**What you can do:**
- Create events
- Update events
- Delete events
- Get events
- Find free/busy times

**Common workflows:**
- Meeting reminders
- Automated scheduling
- Calendar syncing
- Availability checking

**Example:**
```
Trigger: 30 minutes before meeting
Action: Send Slack reminder with meeting link
```

---

## 💡 Tips & Best Practices

### Workflow Design

**Keep it Simple**
- Start with simple workflows
- Add complexity gradually
- One workflow = one clear purpose

**Name Things Clearly**
- Use descriptive workflow names
- Label nodes clearly
- Add notes to complex logic

**Test Thoroughly**
- Use "Execute node" to test each step
- Test with real data
- Check error handling

### Performance

**Optimize Timing**
- Don't run workflows too frequently
- Use appropriate intervals
- Consider time zones

**Handle Errors**
- Add error handling nodes
- Set up failure notifications
- Keep logs clean

**Manage Data**
- Don't process huge datasets at once
- Use filters to reduce data
- Clean up old executions

### Security

**Protect Credentials**
- Never share credentials
- Use separate credentials for each integration
- Rotate credentials periodically

**Limit Access**
- Only connect necessary accounts
- Review permissions regularly
- Revoke unused access

**Be Careful With Data**
- Don't log sensitive information
- Use appropriate channels for notifications
- Follow data privacy policies

---

## 🆘 Troubleshooting

### Workflow Won't Activate

**Problem:** Toggle switch won't stay on

**Solutions:**
1. Check if all nodes are configured
2. Verify credentials are connected
3. Look for error messages in nodes
4. Test each node individually

### Workflow Failed

**Problem:** Execution shows red/error

**Solutions:**
1. Click on the failed execution
2. Look at the error message
3. Check which node failed
4. Common issues:
   - Invalid credentials
   - Missing permissions
   - Malformed data
   - API rate limits

### Credential Issues

**Problem:** "Authentication failed" errors

**Solutions:**
1. Re-authenticate the credential
2. Check if token expired
3. Verify permissions/scopes
4. Test in a simple workflow
5. Contact admin if needed

### Workflow Running But Not Working

**Problem:** No errors but nothing happens

**Solutions:**
1. Check workflow is active
2. Verify trigger conditions
3. Test trigger manually
4. Check data flow between nodes
5. Look at execution logs

### Node Not Working

**Problem:** Specific node failing or stuck

**Solutions:**
1. Check node configuration
2. Verify API limits not exceeded
3. Test with simpler input
4. Check if service is down
5. Update node to latest version

### Performance Issues

**Problem:** Workflows running slowly

**Solutions:**
1. Reduce data being processed
2. Add filters earlier in workflow
3. Optimize API calls
4. Split into multiple workflows
5. Run less frequently

---

## 📞 Getting Help

### Internal Resources

**Documentation:**
- This User Guide
- Integration Setup Guides
- Workflow Templates
- Video Tutorials

**Support Channel:**
- Slack: #obxflow-support
- Ask questions anytime
- Share workflow ideas
- Report issues

### Quick Help

**Common Questions:**

**Q: How do I get access?**
A: Contact your team administrator

**Q: Can I delete workflows?**
A: Yes, but be careful with shared workflows

**Q: How often can workflows run?**
A: As frequently as every minute, but be mindful of rate limits

**Q: Can I share workflows?**
A: Yes, workflows are visible to all team members

**Q: What if I break something?**
A: Don't worry! You can deactivate workflows and admins can restore

### Contact Admin

**For:**
- New integrations
- Permission issues
- Feature requests
- Training sessions
- Critical issues

**Reach out to:** IT Team or Project Lead

---

## 📚 Additional Resources

### Learning Resources

**Video Tutorials:**
- Getting Started with OBxFlow (5 min)
- Creating Your First Workflow (10 min)
- Integration Setup Guide (15 min)
- Advanced Workflow Techniques (20 min)

**Documentation:**
- N8N Official Docs: https://docs.n8n.io
- Workflow Examples: [Internal link]
- Integration Guides: [Internal link]

### Workflow Templates

Check the **"Templates"** section for:
- Daily standup reminders
- New hire onboarding
- Lead notifications
- Report generation
- Birthday announcements
- Meeting reminders
- File backups
- And many more!

### Community

**Share Your Ideas:**
- Post in #obxflow-support
- Suggest new integrations
- Share workflow tips
- Help teammates

**Stay Updated:**
- Follow #obxflow-announcements
- Check for new features
- Attend training sessions
- Review changelog

---

## 🎓 Next Steps

Now that you've learned the basics:

1. **Explore** existing workflows
2. **Create** your first simple workflow
3. **Experiment** with integrations
4. **Share** your workflows with the team
5. **Ask** questions in #obxflow-support

**Remember:** Everyone was a beginner once. Don't hesitate to ask questions!

---

## 📋 Quick Reference Card

### Common Shortcuts

| Action | Shortcut |
|--------|----------|
| Save workflow | Cmd/Ctrl + S |
| Execute workflow | Cmd/Ctrl + Enter |
| Search nodes | Cmd/Ctrl + K |
| Undo | Cmd/Ctrl + Z |
| Redo | Cmd/Ctrl + Shift + Z |

### Common Nodes

- **Schedule Trigger** - Time-based workflows
- **Webhook Trigger** - External triggers
- **Slack** - Send/receive Slack messages
- **Gmail** - Send/receive emails
- **Google Drive** - File operations
- **HTTP Request** - API calls
- **Code** - Custom JavaScript/Python
- **IF** - Conditional logic
- **Switch** - Multiple conditions

### Status Icons

- ✅ - Successfully executed
- ❌ - Failed execution
- ⏸️ - Inactive/Paused
- ▶️ - Currently running
- ⏱️ - Scheduled/Waiting

---

**Happy Automating! 🚀**

*If you found this guide helpful, share it with your teammates!*

---

**Questions or feedback?** Post in #obxflow-support
