# OBxFlow 2.0

**Internal Chat & Automation Platform for OuterBox**

A fully branded N8N instance customized as OuterBox's internal communication and workflow automation platform.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)
[![OuterBox](https://img.shields.io/badge/Brand-OuterBox-1D4E89)](https://www.outerbox.com)

---

## 🎯 Overview

OBxFlow 2.0 is a self-hosted N8N automation platform, fully customized with OuterBox branding, designed to serve as our internal automation and workflow engine. It connects our tools, automates repetitive tasks, and empowers the team to build custom workflows without coding.

**Key Features:**
- 🎨 **Full OuterBox Branding** - Custom theme with our colors, logos, and fonts
- 🔗 **Pre-configured Integrations** - Slack, Google Workspace, and more
- 🤖 **Workflow Automation** - No-code/low-code automation builder
- 🔒 **Secure & Private** - Self-hosted, enterprise-grade security
- 📊 **Real-time Monitoring** - Track workflow executions and performance
- 👥 **Multi-user Support** - Team collaboration on workflows

---

## 🚀 Quick Start

### Prerequisites

- Docker & Docker Compose installed
- 2GB+ RAM available
- Ports 5678 available

### Launch OBxFlow

```bash
# Clone the repository
git clone https://github.com/outerbox-dev/OBxFlow2.0.git
cd OBxFlow2.0

# Configure environment
cp n8n/.env.example n8n/.env
# Edit n8n/.env and set your passwords

# Start the stack
cd n8n
docker-compose up -d

# Access OBxFlow
open http://localhost:5678
```

**Default Login:**
- Username: `admin`
- Password: (check your `.env` file)

For detailed setup instructions, see [Installation Guide](./docs/setup/INSTALLATION.md).

---

## 📚 Documentation

- **Setup Guides**
  - [Quick Start](./docs/setup/QUICKSTART.md) - Get running in 5 minutes
  - [Installation](./docs/setup/INSTALLATION.md) - Detailed setup instructions
  - [Configuration](./docs/setup/CONFIGURATION.md) - Advanced configuration

- **User Guides**
  - [User Guide](./docs/guides/USER_GUIDE.md) - How to use OBxFlow
  - [Workflow Creation](./docs/guides/WORKFLOW_CREATION.md) - Build your first workflow
  - [Integrations](./docs/guides/INTEGRATIONS.md) - Connect your tools

- **Brand Standards**
  - [Branding Guide](./docs/brand/BRANDING_GUIDE.md) - OuterBox brand implementation
  - [Brand Standards PDF](./BrandStandards__OBx_2025.pdf) - Official brand guidelines

- **Development**
  - [AI Development Practices](./.ai/00-AI_DEVELOPMENT_PRACTICES.md) - Multi-agent development
  - [Project Mission](./.ai/01-PROJECT_MISSION.md) - Goals and objectives
  - [Technical Requirements](./.ai/02-REQUIREMENTS.md) - System requirements
  - [Roadmap](./.ai/06-ROADMAP.md) - Development roadmap

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────┐
│           OBxFlow 2.0 Platform              │
├─────────────────────────────────────────────┤
│  Custom Branding (OuterBox Theme)          │
├─────────────────────────────────────────────┤
│  N8N Core (Workflow Engine)                │
├─────────────────────────────────────────────┤
│  PostgreSQL (Database)                      │
├─────────────────────────────────────────────┤
│  Docker (Container Platform)                │
└─────────────────────────────────────────────┘
```

**Technology Stack:**
- **Runtime:** Docker Compose
- **Workflow Engine:** N8N (latest)
- **Database:** PostgreSQL 15
- **Web Server:** N8N built-in
- **Storage:** Docker volumes
- **Branding:** Custom CSS & assets

---

## 🎨 OuterBox Branding

OBxFlow implements the **OuterBox Brand Standards 2025** throughout:

**Colors:**
- Dark Blue (`#17212E`) - Primary navigation and text
- OBx Blue (`#1D4E89`) - Primary actions and CTAs
- Orange (`#C75300`) - Accent elements
- Gold (`#FFB703`) - Highlights on dark backgrounds
- Frost (`#EEF3F6`) - Light backgrounds

**Typography:**
- **Font Family:** Roboto (all weights)
- **Headings:** Roboto Black/Bold
- **Body Text:** Roboto Regular

**Logo:**
- OuterBox® wordmark
- "OBx" acronym (lowercase 'x')
- Proper spacing and trademark

See [Branding Guide](./docs/brand/BRANDING_GUIDE.md) for complete implementation details.

---

## 🔗 Integrations

OBxFlow comes pre-configured for OuterBox tools:

**Included Integrations:**
- ✅ **Slack** - Team messaging and notifications
- ✅ **Google Workspace** - Gmail, Drive, Calendar
- ✅ **Webhooks** - Custom API endpoints
- ✅ **HTTP Requests** - REST API calls
- ✅ **Scheduling** - Cron-based triggers

**Easy to Add:**
- CRM systems (HubSpot, Salesforce)
- Analytics platforms (Google Analytics, Mixpanel)
- Project management (Asana, Monday.com)
- Marketing tools (Mailchimp, SendGrid)
- Development tools (GitHub, Jira)

See [Integrations Guide](./docs/guides/INTEGRATIONS.md) for setup instructions.

---

## 🤖 Example Workflows

Get started quickly with these pre-built workflow templates:

### 1. Welcome New Team Member
Automatically onboard new employees when added to Google Workspace:
- Send welcome Slack message
- Create personal Drive folder
- Add to team calendar
- Assign onboarding tasks

### 2. Daily Standup Reminder
Send automated reminders to team channels:
- Schedule: Weekdays 8:45 AM
- Post to Slack with meeting link
- Include agenda and previous notes

### 3. Client Report Generator
Automate reporting workflow:
- Pull data from multiple sources
- Generate formatted report
- Email to stakeholders
- Archive in Drive

### 4. Lead Notification
Instant alerts for new leads:
- Webhook trigger from website form
- Parse and enrich lead data
- Notify sales team via Slack
- Log to CRM and spreadsheet

### 5. Birthday Announcements
Celebrate team members:
- Daily check of birthdays
- Post congratulations to Slack
- Send gift card or swag reminder
- Update calendar

See [Workflow Templates](./workflows/templates/) for more examples.

---

## 🛠️ Development

### Project Structure

```
OBxFlow2.0/
├── .ai/                    # AI development documentation
├── docs/                   # User documentation
├── n8n/                    # N8N deployment configs
│   ├── docker-compose.yml  # Docker orchestration
│   ├── .env.example        # Environment template
│   └── custom/             # Custom branding & nodes
│       └── branding/       # OuterBox theme
│           ├── css/        # Custom stylesheets
│           ├── logos/      # OuterBox logos
│           └── images/     # Brand imagery
├── workflows/              # Workflow templates
│   ├── templates/          # Starter templates
│   └── examples/           # Example workflows
└── README.md               # This file
```

### Multi-Agent Development

This project uses an AI-driven development approach with multiple agents:

- **Product Director** - Strategic planning and oversight
- **Claude Code** - Technical implementation via local-dev-bridge
- **Documentation Agent** - User guides and API docs

See [AI Development Practices](./.ai/00-AI_DEVELOPMENT_PRACTICES.md) for details.

---

## 🔒 Security

**Security Features:**
- Basic authentication enabled by default
- HTTPS ready (add reverse proxy)
- Environment-based secrets management
- No credentials in code
- Regular security updates
- Audit logging

**Best Practices:**
- Change default passwords immediately
- Use strong, unique passwords
- Enable 2FA where possible
- Regular backups
- Keep Docker images updated
- Monitor access logs

See `.env.example` for required environment variables.

---

## 📊 Monitoring & Maintenance

### Health Checks

```bash
# Check service status
docker-compose ps

# View logs
docker-compose logs -f n8n

# Check database connection
docker-compose exec postgres pg_isready
```

### Backups

Automated backups run daily:
- Workflow exports (JSON)
- Database dumps (PostgreSQL)
- Configuration files

Manual backup:
```bash
cd n8n
./scripts/backup.sh
```

### Updates

Update to latest N8N version:
```bash
cd n8n
docker-compose pull
docker-compose up -d
```

---

## 🤝 Contributing

This is an internal OuterBox project. Contributions from team members are welcome!

**Guidelines:**
1. Follow OuterBox brand standards
2. Document all workflows
3. Test before committing
4. Use meaningful commit messages
5. Create issues for bugs/features

**Workflow:**
1. Create feature branch from `main`
2. Make changes
3. Test locally
4. Submit pull request
5. Request review from team lead

---

## 📞 Support

**Internal Support:**
- Slack: #obxflow-support
- Email: devops@outerbox.com
- Issues: [GitHub Issues](https://github.com/outerbox-dev/OBxFlow2.0/issues)

**N8N Resources:**
- [Official Documentation](https://docs.n8n.io/)
- [Community Forum](https://community.n8n.io/)
- [YouTube Tutorials](https://www.youtube.com/c/n8nio)

---

## 📝 License

MIT License - See [LICENSE](./LICENSE) file for details.

Copyright © 2025 OuterBox. All rights reserved.

---

## 🙏 Acknowledgments

- **N8N Team** - Excellent open-source automation platform
- **OuterBox Marketing** - Brand standards and design guidance
- **OuterBox DevOps** - Infrastructure and deployment support
- **OuterBox Team** - Feedback and workflow ideas

---

## 🎉 Get Started!

Ready to automate? Follow the [Quick Start](#-quick-start) guide above and start building workflows in minutes!

Questions? Check the [Documentation](#-documentation) or reach out on Slack.

**Let's automate everything!** 🚀
