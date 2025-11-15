# Integration Setup Guide

**OBxFlow Integration Configuration**  
**Last Updated:** November 15, 2025

---

## 📋 Table of Contents

1. [Slack Integration](#slack-integration)
2. [Google Workspace Integration](#google-workspace-integration)
3. [Email (SMTP) Configuration](#email-smtp-configuration)
4. [Webhook Setup](#webhook-setup)
5. [Testing Integrations](#testing-integrations)
6. [Troubleshooting](#troubleshooting)

---

## 💬 Slack Integration

### Prerequisites
- Slack workspace admin access
- OuterBox Slack workspace

### Step 1: Create Slack App

1. **Go to Slack API Portal**
   - Navigate to: https://api.slack.com/apps
   - Click **"Create New App"**
   - Select **"From scratch"**

2. **Configure Basic Information**
   - **App Name:** `OBxFlow Bot`
   - **Workspace:** Select OuterBox workspace
   - Click **"Create App"**

### Step 2: Configure OAuth & Permissions

1. **Navigate to OAuth & Permissions** (left sidebar)

2. **Add Bot Token Scopes:**
   Click **"Add an OAuth Scope"** under Bot Token Scopes
   
   **Essential Scopes:**
   - `chat:write` - Post messages
   - `chat:write.public` - Post to public channels without joining
   - `channels:read` - View basic channel information
   - `channels:history` - View messages in public channels
   - `users:read` - View people in workspace
   - `users:read.email` - View email addresses of people
   - `files:write` - Upload, edit, and delete files
   
   **Optional Scopes (add if needed):**
   - `groups:read` - View basic private channel info
   - `groups:history` - View messages in private channels
   - `im:read` - View basic direct message info
   - `im:history` - View messages in direct messages
   - `reactions:read` - View emoji reactions
   - `reactions:write` - Add and edit emoji reactions

3. **Set Redirect URL**
   - Under **"Redirect URLs"** click **"Add New Redirect URL"**
   - Enter: `http://localhost:5678/rest/oauth2-credential/callback`
   - Click **"Add"**
   - Click **"Save URLs"**

### Step 3: Install App to Workspace

1. **Scroll to "OAuth Tokens for Your Workspace"**
2. Click **"Install to Workspace"**
3. Review permissions
4. Click **"Allow"**
5. **Copy the Bot User OAuth Token** (starts with `xoxb-`)
   - Save this securely - you'll need it for N8N

### Step 4: Configure in N8N

1. **Open N8N** at http://localhost:5678
2. **Navigate to:** Credentials → New Credential
3. **Select:** Slack OAuth2 API
4. **Enter:**
   - **OAuth2 Token:** Paste the `xoxb-` token from Step 3
   - **Slack Subdomain:** `outerbox` (or your workspace name)
5. **Click:** Create
6. **Test:** Create a simple workflow that sends a message

### Step 5: Enable Event Subscriptions (Optional)

If you want to receive events from Slack:

1. **Navigate to Event Subscriptions** in Slack App settings
2. **Enable Events**
3. **Request URL:** `http://your-n8n-domain/webhook/slack`
4. **Subscribe to bot events:**
   - `message.channels` - Receive messages in public channels
   - `message.im` - Receive direct messages
   - `reaction_added` - Receive reaction events
5. **Save Changes**

### Testing Slack Integration

Create a test workflow:
```
1. Manual Trigger
2. Slack → Send Message
   - Channel: #general
   - Message: "Hello from OBxFlow! 🚀"
3. Execute workflow
```

---

## 🔐 Google Workspace Integration

### Prerequisites
- Google Cloud Console access
- Google Workspace admin rights
- OuterBox Google Workspace account

### Step 1: Set Up Google Cloud Project

1. **Go to Google Cloud Console**
   - Navigate to: https://console.cloud.google.com
   - Sign in with OuterBox Google account

2. **Create New Project**
   - Click project dropdown (top left)
   - Click **"New Project"**
   - **Project Name:** `OBxFlow`
   - **Organization:** OuterBox
   - Click **"Create"**

3. **Select Your Project**
   - Ensure "OBxFlow" is selected in project dropdown

### Step 2: Enable Required APIs

1. **Navigate to APIs & Services** → **Library**

2. **Enable these APIs:** (search and enable each)
   - ✅ Gmail API
   - ✅ Google Drive API
   - ✅ Google Calendar API
   - ✅ Google Sheets API (optional)
   - ✅ Google Docs API (optional)

### Step 3: Configure OAuth Consent Screen

1. **Navigate to:** APIs & Services → OAuth consent screen

2. **Configure:**
   - **User Type:** Internal (for OuterBox users only)
   - Click **"Create"**

3. **App Information:**
   - **App name:** `OBxFlow`
   - **User support email:** your-email@outerbox.com
   - **App logo:** Upload OuterBox logo (optional)
   - **Application home page:** `http://localhost:5678`

4. **Authorized Domains:**
   - Add: `outerbox.com`
   - Add: `localhost` (for testing)

5. **Developer Contact:**
   - Email: your-email@outerbox.com

6. **Scopes:** Click **"Add or Remove Scopes"**
   
   **For Gmail:**
   - `.../auth/gmail.send` - Send emails
   - `.../auth/gmail.readonly` - Read emails
   - `.../auth/gmail.modify` - Modify emails
   
   **For Google Drive:**
   - `.../auth/drive` - Full Drive access
   - `.../auth/drive.file` - Per-file access
   
   **For Google Calendar:**
   - `.../auth/calendar` - Full Calendar access
   - `.../auth/calendar.events` - Event access

7. Click **"Save and Continue"**
8. Review and click **"Back to Dashboard"**

### Step 4: Create OAuth 2.0 Credentials

1. **Navigate to:** APIs & Services → Credentials

2. **Create Credentials:**
   - Click **"Create Credentials"** → **"OAuth 2.0 Client ID"**

3. **Application Type:** Web application

4. **Name:** `N8N OBxFlow`

5. **Authorized JavaScript Origins:**
   - `http://localhost:5678`
   - `https://your-domain.com` (if deploying)

6. **Authorized Redirect URIs:**
   - `http://localhost:5678/rest/oauth2-credential/callback`
   - `https://your-domain.com/rest/oauth2-credential/callback` (if deploying)

7. Click **"Create"**

8. **Copy credentials:**
   - **Client ID:** (looks like `123456-abc.apps.googleusercontent.com`)
   - **Client Secret:** (random string)
   - Save these securely

### Step 5: Configure Gmail in N8N

1. **Open N8N** at http://localhost:5678
2. **Navigate to:** Credentials → New Credential
3. **Select:** Gmail OAuth2 API
4. **Enter:**
   - **OAuth2 Client ID:** Paste from Step 4
   - **OAuth2 Client Secret:** Paste from Step 4
5. Click **"Connect my account"**
6. **Authorize:** Sign in with Google and grant permissions
7. **Save**

### Step 6: Configure Google Drive in N8N

Repeat Step 5 but select **"Google Drive OAuth2 API"**

### Step 7: Configure Google Calendar in N8N

Repeat Step 5 but select **"Google Calendar OAuth2 API"**

### Testing Google Integrations

**Gmail Test:**
```
1. Manual Trigger
2. Gmail → Send Message
   - To: your-email@outerbox.com
   - Subject: "OBxFlow Test"
   - Message: "Integration working!"
3. Execute workflow
```

**Google Drive Test:**
```
1. Manual Trigger
2. Google Drive → List Files
   - Folder ID: root
3. Execute workflow
```

**Google Calendar Test:**
```
1. Manual Trigger
2. Google Calendar → Get All Events
   - Calendar: Primary
   - Start: Today
   - End: Tomorrow
3. Execute workflow
```

---

## 📧 Email (SMTP) Configuration

### Using Gmail SMTP

1. **Enable 2-Step Verification** (if not already)
   - Go to: https://myaccount.google.com/security
   - Enable 2-Step Verification

2. **Create App Password**
   - Go to: https://myaccount.google.com/apppasswords
   - Select **"Mail"** and **"Other"**
   - Name: `OBxFlow`
   - Click **"Generate"**
   - **Copy the password** (16 characters)

3. **Configure in N8N**
   - Credentials → New Credential
   - Select: **SMTP**
   - **User:** your-email@outerbox.com
   - **Password:** App password from step 2
   - **Host:** smtp.gmail.com
   - **Port:** 587
   - **Secure:** No (TLS will be used)
   - Save

### Using OuterBox SMTP (if available)

Ask your IT administrator for:
- SMTP Host
- SMTP Port
- Username
- Password
- Security settings (TLS/SSL)

Then configure in N8N as above.

---

## 🔗 Webhook Setup

### Creating a Webhook in N8N

1. **In your workflow, add:** Webhook node (as trigger)

2. **Configure:**
   - **HTTP Method:** POST (or GET)
   - **Path:** Choose unique path (e.g., `obxflow-lead`)
   - **Authentication:** None or Basic Auth

3. **Get Webhook URL:**
   - Will be: `http://localhost:5678/webhook/obxflow-lead`
   - For production: `https://your-domain.com/webhook/obxflow-lead`

4. **Test Webhook:**
   ```bash
   curl -X POST http://localhost:5678/webhook/obxflow-lead \
     -H "Content-Type: application/json" \
     -d '{"name":"Test","email":"test@example.com"}'
   ```

### Securing Webhooks

**Option 1: Basic Authentication**
- In Webhook node, enable "Basic Auth"
- Set username and password
- Clients must include: `Authorization: Basic <base64-encoded-credentials>`

**Option 2: Header Authentication**
- Add HTTP Request node after Webhook
- Check for specific header value
- Use IF node to validate

**Option 3: IP Whitelist**
- Configure in N8N settings or firewall
- Only allow requests from specific IPs

---

## ✅ Testing Integrations

### Testing Checklist

**Slack:**
- [ ] Can send message to public channel
- [ ] Can send direct message
- [ ] Can upload file
- [ ] Can read channel info

**Gmail:**
- [ ] Can send email
- [ ] Can read emails
- [ ] Can search emails

**Google Drive:**
- [ ] Can list files
- [ ] Can upload file
- [ ] Can create folder
- [ ] Can share file

**Google Calendar:**
- [ ] Can list events
- [ ] Can create event
- [ ] Can update event

**Webhooks:**
- [ ] Can receive POST requests
- [ ] Can receive GET requests
- [ ] Data is parsed correctly

### Integration Test Workflow

Create a comprehensive test workflow:

```
1. Manual Trigger
2. Slack → Send Message ("Starting integration tests...")
3. Gmail → Send Email (to yourself)
4. Google Drive → Create Folder (test folder)
5. Google Calendar → Create Event (test event)
6. Slack → Send Message ("All tests complete! ✅")
```

---

## 🆘 Troubleshooting

### Slack Issues

**"Invalid Token" Error**
- Token may have expired
- Reinstall app to workspace
- Regenerate token

**"Missing Scopes" Error**
- Add required scope in Slack App settings
- Reinstall app to workspace

**"Channel Not Found"**
- Verify channel exists
- Check spelling (use channel ID instead)
- Add bot to private channels

### Google Issues

**"Insufficient Permissions" Error**
- Review OAuth scopes in Google Cloud Console
- Re-authenticate credential in N8N
- Ensure APIs are enabled

**"API Not Enabled" Error**
- Go to Google Cloud Console
- Enable the required API
- Wait a few minutes for propagation

**"Invalid Grant" Error**
- OAuth token expired
- Re-authenticate in N8N
- Check if user still has access

### General Issues

**"Connection Timeout"**
- Check internet connection
- Verify firewall settings
- Check if service is down

**"Rate Limit Exceeded"**
- Reduce workflow frequency
- Implement exponential backoff
- Contact service for limit increase

**"Credential Not Found"**
- Ensure credential is saved
- Check credential name in nodes
- Verify credential is connected

---

## 📝 Credential Management

### Best Practices

1. **Use Descriptive Names**
   - Good: "OuterBox Slack - Marketing"
   - Bad: "Slack 1"

2. **Rotate Credentials Regularly**
   - Every 90 days for production
   - Immediately if compromised

3. **Limit Scope**
   - Only grant necessary permissions
   - Use service accounts when possible

4. **Document Credentials**
   - Keep registry in `.ai/05-CREDENTIALS.md`
   - Note: who created, when, for what

5. **Revoke Unused Credentials**
   - Regular audit (quarterly)
   - Remove old integrations

---

## 🔐 Security Notes

- **Never share credentials** via email or chat
- **Use environment variables** for production
- **Enable 2FA** on all service accounts
- **Monitor usage** for suspicious activity
- **Have backup credentials** for critical services

---

**Questions?** Contact IT team or post in #obxflow-support
