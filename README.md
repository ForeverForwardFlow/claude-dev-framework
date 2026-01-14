# Claude Code Development Framework

A standardized project structure for AI-assisted software development with Claude Code. This template provides:

- **Consistent folder structure** for frontend and backend projects
- **CLAUDE.md files** with development standards and conventions
- **Automation scripts** for project initialization and tooling
- **Pre-configured workflows** for TDD, linting, and testing

## Structure

```
.
├── backend/
│   └── CLAUDE.md           # Backend development standards (Cloudflare Workers, TypeScript)
├── frontend/
│   ├── CLAUDE.md           # Frontend development standards (Vue 3, Quasar, TypeScript)
│   └── claude_tools/       # Automation scripts and templates
│       ├── init-project.sh              # Initialize new Quasar projects
│       ├── start-chrome-debug.sh        # Launch Chrome with debugging
│       ├── CLAUDE-quasar-template.md    # Template copied to new projects
│       ├── claude-settings-template.json # Claude Code hooks config
│       └── vue-quasar-claude-code-workflow.md  # Detailed workflow docs
└── README.md
```

## Quick Start

### Create a New Frontend Project

```bash
cd frontend
./claude_tools/init-project.sh my-app
cd my-app
quasar dev
```

This automatically configures:
- Vue 3 + Quasar + TypeScript + Pinia
- Vitest (unit testing) + Playwright (E2E)
- ESLint + Prettier + Husky + Commitlint
- Claude Code hooks for autonomous development

### Create a New Backend Project

Backend projects are typically created manually or with Wrangler:

```bash
cd backend
npm create cloudflare@latest my-api
```

Then reference `backend/CLAUDE.md` for conventions and patterns.

## Development Standards

### Frontend (Vue 3 + Quasar)

- **Composition API** with `<script setup lang="ts">`
- **TDD workflow** - Write tests before implementation
- **Quasar components** - Use Q* components over raw HTML
- **Pinia stores** - Composition API style with setup functions
- **Vitest + Playwright** - Unit and E2E testing

### Backend (Cloudflare Workers)

- **TypeScript strict mode** - No `any` types
- **Zod validation** - Schema validation for all inputs
- **Error sanitization** - Redact sensitive data from errors
- **Vitest testing** - Comprehensive test coverage

### Both

- **Conventional Commits** - `feat:`, `fix:`, `docs:`, etc.
- **Pre-commit hooks** - Lint, format, and test before commit
- **CLAUDE.md per project** - Project-specific guidance for Claude Code

## MCP Server Integration

The frontend CLAUDE.md documents integration with MCP servers:

| Server | Purpose |
|--------|---------|
| `context7` | Real-time documentation for Vue/Quasar/Pinia |
| `playwright` | Browser automation and visual testing |
| `chrome-devtools` | Console logs, network inspection |
| `figma` | Design import and token extraction |
| `axe-accessibility` | WCAG compliance auditing |

## Using This Template

1. Click **"Use this template"** on GitHub
2. Clone your new repository
3. Start creating projects in `frontend/` and `backend/`

## License

MIT
