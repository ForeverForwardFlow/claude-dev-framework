# Claude Code Development Framework

This is a template repository providing standardized development workflows for AI-assisted software development.

## Repository Structure

```
.
├── backend/           # Backend projects (Cloudflare Workers, APIs)
│   └── CLAUDE.md      # Backend-specific development standards
├── frontend/          # Frontend projects (Vue 3, Quasar)
│   ├── CLAUDE.md      # Frontend-specific development standards
│   └── claude_tools/  # Automation scripts
└── CLAUDE.md          # This file - root-level guidance
```

## For Claude Code

When working in this repository:

1. **Check the appropriate CLAUDE.md** for the project type:
   - Frontend projects: Read `frontend/CLAUDE.md`
   - Backend projects: Read `backend/CLAUDE.md`

2. **Use subagents** for complex tasks:
   - `Explore` - Codebase exploration
   - `test-engineer` - Writing test suites
   - `code-reviewer` - Code review
   - `implementer` - Focused implementation

3. **Follow TDD** - Write tests before implementation

4. **Use conventional commits** - `feat:`, `fix:`, `docs:`, etc.

## Creating New Projects

### Frontend

```bash
cd frontend
./claude_tools/init-project.sh <project-name>
```

### Backend

Create manually or with Wrangler, following patterns in `backend/CLAUDE.md`.

## Key Files

| File | Purpose |
|------|---------|
| `frontend/CLAUDE.md` | Vue 3 + Quasar conventions, testing patterns |
| `backend/CLAUDE.md` | Cloudflare Workers conventions, validation patterns |
| `frontend/claude_tools/init-project.sh` | Project scaffolding with full tooling |
| `frontend/claude_tools/CLAUDE-quasar-template.md` | Template for new project CLAUDE.md |
