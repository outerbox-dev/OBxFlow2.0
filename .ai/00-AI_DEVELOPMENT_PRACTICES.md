# AI Development Practices for OBxFlow 2.0

**Purpose:** Multi-agent AI development framework for optimal collaboration  
**Version:** 1.0  
**Last Updated:** November 15, 2025

---

## 🎯 Overview

This project leverages multiple AI agents working in concert to design, build, deploy, and maintain OBxFlow 2.0. This document defines the practices, protocols, and patterns for effective AI-driven development.

---

## 🤖 Agent Roles & Responsibilities

### Product Director Agent
**Role:** Strategic Product Leadership

**Responsibilities:**
- Define project vision and objectives
- Create strategic briefs for development agents
- Review implementations against requirements
- Make architectural decisions
- Manage project roadmap
- Validate quality and brand compliance
- Communicate with stakeholders

**Capabilities:**
- Strategic thinking and planning
- Requirements analysis
- Quality assurance
- Documentation review
- Priority management

**Does NOT:**
- Write implementation code directly
- Execute git commands
- Run build processes
- Debug syntax errors
- Configure deployment manually

### Claude Code Agent (via local-dev-bridge)
**Role:** Technical Implementation

**Responsibilities:**
- Execute technical implementation
- Create and modify files
- Run commands and scripts
- Deploy Docker infrastructure
- Configure integrations
- Apply branding
- Report execution results

**Capabilities:**
- File system operations (read/write/edit)
- Command execution (bash, npm, docker)
- Directory management
- Git operations
- Testing and verification

**Does NOT:**
- Make strategic decisions
- Change project requirements
- Modify brand standards
- Approve final deliverables

---

## 📝 Communication Protocol

### Strategic Brief Format

When Product Director delegates to Claude Code:

```markdown
## Mission
[Clear, concise objective]

## Context
[Business need and technical background]

## Requirements
[Specific, measurable requirements]

## Technical Constraints
[Limitations and dependencies]

## Success Criteria
[Measurable outcomes]

## Deliverable
[Expected output]
```

### Execution Report Format

When Claude Code reports back:

```markdown
## Summary
[What was accomplished]

## Files Created/Modified
[List of files with purposes]

## Commands Executed
[Key commands run]

## Status
[Success/issues encountered]

## Next Steps
[Recommended follow-up]
```

---

## 🏗️ Development Workflow

### Phase 1: Discovery & Planning
1. Product Director analyzes requirements
2. Creates comprehensive project brief
3. Defines success criteria
4. Breaks work into phases

### Phase 2: Strategic Brief Creation
1. Director creates detailed brief for Claude Code
2. Includes all specifications
3. References brand standards
4. Provides examples and templates

### Phase 3: Implementation Execution
1. Claude Code receives brief
2. Executes technical work
3. Creates/modifies files
4. Tests implementation
5. Reports results

### Phase 4: Review & Validation
1. Product Director reviews output
2. Validates against requirements
3. Checks brand compliance
4. Tests functionality
5. Provides feedback

### Phase 5: Iteration
1. Director identifies gaps or issues
2. Creates refined brief
3. Claude Code makes adjustments
4. Repeat until success criteria met

### Phase 6: Documentation
1. Director ensures documentation complete
2. Creates user guides
3. Documents decisions (ADRs)
4. Updates roadmap

---

## 📚 Documentation Standards

### File Naming Conventions

```
.ai/00-AI_DEVELOPMENT_PRACTICES.md    # This file
.ai/01-PROJECT_MISSION.md              # Business goals
.ai/02-REQUIREMENTS.md                 # Technical requirements
.ai/03-FEATURES.md                     # Feature specifications
.ai/04-ENVIRONMENT.md                  # Environment setup
.ai/05-CREDENTIALS.md                  # Credentials (git-ignored)
.ai/06-ROADMAP.md                      # Development roadmap
.ai/07-BUGS_RESOLUTIONS.md             # Bug tracking
```

### Documentation Requirements

**Every documentation file must include:**
- Clear title and purpose
- Version number
- Last updated date
- Table of contents (if >500 words)
- Examples where applicable
- Links to related documents

**Writing Style:**
- Clear, concise language
- Active voice
- Specific, actionable content
- Professional tone
- OuterBox-specific examples

---

## 🎨 Brand Compliance

### Automatic Brand Checks

All agents must validate:
- ✅ Colors match OuterBox palette exactly
- ✅ Roboto font family used
- ✅ Logo placement follows guidelines
- ✅ Adequate spacing (not cramped)
- ✅ Professional appearance
- ✅ Consistent with brand standards

### Brand Standards Reference

Primary source: `BrandStandards__OBx_2025.pdf`

**Key Brand Elements:**
- **Colors:** Dark Blue (#17212E), OBx Blue (#1D4E89), Orange (#C75300), Gold (#FFB703)
- **Typography:** Roboto font family (Black/Bold for headings, Regular for body)
- **Logo:** "OBx" acronym with ® trademark
- **Visual Style:** Clean, professional, modern

---

## 🔄 Version Control Practices

### Git Workflow

```bash
# Create feature branch
git checkout -b feature/feature-name

# Make changes
# Test locally

# Commit with clear message
git commit -m "feat: add feature X"

# Push and create PR
git push origin feature/feature-name
```

### Commit Message Format

```
type(scope): subject

body (optional)

footer (optional)
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Code restructuring
- `test`: Testing
- `chore`: Maintenance

### Branch Protection

- `main`: Protected, requires PR
- Feature branches: Created from `main`
- Hotfixes: Created from `main`, merged directly

---

## 🧪 Testing Strategy

### Testing Levels

**1. Unit Testing**
- Individual workflow nodes
- Configuration validation
- Custom functions

**2. Integration Testing**
- Workflow execution end-to-end
- API integrations
- Database connectivity

**3. User Acceptance Testing**
- Team member feedback
- Real workflow scenarios
- Brand compliance check

**4. Performance Testing**
- Workflow execution time
- Database query performance
- API rate limits

### Testing Checklist

Before marking work complete:
- [ ] All files created successfully
- [ ] No syntax errors
- [ ] Docker services start
- [ ] N8N accessible
- [ ] Workflows execute
- [ ] Integrations work
- [ ] Brand standards met
- [ ] Documentation complete
- [ ] No credentials exposed

---

## 📊 Project Management

### Issue Tracking

**Issue Types:**
- `feature`: New capability
- `bug`: Something broken
- `enhancement`: Improvement
- `documentation`: Doc updates
- `question`: Need clarification

**Issue Template:**
```markdown
## Description
[What needs to be done]

## Context
[Why this is needed]

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Notes
[Additional information]
```

### Project Board Columns

1. **Backlog** - Future work
2. **To Do** - Planned for current sprint
3. **In Progress** - Currently being worked
4. **Review** - Awaiting validation
5. **Done** - Complete and deployed

---

## 🚨 Error Handling

### When Things Go Wrong

**Product Director Response:**
1. Analyze what went wrong
2. Determine if issue is strategic or technical
3. Provide clarified brief to Claude Code
4. Document lesson learned

**Claude Code Response:**
1. Report error details clearly
2. Suggest potential solutions
3. Request clarification if needed
4. Document in BUGS_RESOLUTIONS.md

### Common Issues & Solutions

**Issue:** Docker containers won't start
**Solution:** Check ports, permissions, Docker service status

**Issue:** N8N login fails
**Solution:** Verify .env credentials, check Basic Auth settings

**Issue:** Branding doesn't apply
**Solution:** Verify CSS files mounted, clear browser cache

**Issue:** Integration fails
**Solution:** Check credentials, API limits, network connectivity

---

## 📈 Success Metrics

### Development Velocity

- **Story Points:** Complexity estimation
- **Cycle Time:** Time from start to done
- **Throughput:** Features completed per sprint

### Quality Metrics

- **Bug Density:** Bugs per feature
- **Test Coverage:** Percentage tested
- **Code Review:** Time to review PRs

### Adoption Metrics

- **User Adoption:** % team using OBxFlow
- **Workflow Count:** Active workflows created
- **Integration Usage:** Which integrations most used

---

## 🎓 Learning & Improvement

### Retrospectives

After each phase:
- What went well?
- What could improve?
- Action items for next phase

### Documentation Updates

Keep this file current:
- Add new patterns discovered
- Document solutions to problems
- Refine communication protocols
- Update examples

---

## 🔗 Related Documents

- [Project Mission](./01-PROJECT_MISSION.md) - Business objectives
- [Requirements](./02-REQUIREMENTS.md) - Technical specifications
- [Roadmap](./06-ROADMAP.md) - Development timeline
- [Bug Tracking](./07-BUGS_RESOLUTIONS.md) - Issue resolution

---

## 📞 Questions?

If these practices need clarification or improvement, update this document and commit changes. All agents should reference this as the source of truth for development practices.

---

**Remember:** Effective multi-agent collaboration requires clear communication, well-defined roles, and consistent practices. Follow these guidelines for optimal results!
