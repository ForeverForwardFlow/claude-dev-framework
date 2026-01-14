# Claude Code Development Framework

A standardized project structure for AI-assisted software development with Claude Code. This template provides:

- **Consistent folder structure** for frontend and backend projects
- **CLAUDE.md files** with development standards and conventions
- **Automation scripts** for rapid project scaffolding
- **Pre-configured workflows** for TDD, linting, and testing

## Structure

```
.
├── backend/
│   ├── CLAUDE.md           # Backend development standards
│   └── claude_tools/       # Backend automation scripts
│       ├── init-project.sh          # Create single Cloudflare Worker
│       ├── init-monorepo.sh         # Create Turborepo monorepo
│       └── CLAUDE-cloudflare-template.md
├── frontend/
│   ├── CLAUDE.md           # Frontend development standards
│   └── claude_tools/       # Frontend automation scripts
│       ├── init-project.sh              # Create Quasar project
│       ├── start-chrome-debug.sh        # Chrome debugging
│       ├── CLAUDE-quasar-template.md
│       ├── claude-settings-template.json
│       └── vue-quasar-claude-code-workflow.md
└── README.md
```

## Quick Start

### Create a New Frontend Project (Vue 3 + Quasar)

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

### Create a New Backend Project (Cloudflare Workers)

```bash
cd backend
./claude_tools/init-project.sh my-api
cd my-api
npm run dev
```

Options:
- `--mcp` flag adds MCP (Model Context Protocol) server boilerplate

This automatically configures:
- TypeScript (strict mode) + Wrangler
- Vitest testing with coverage
- ESLint 9 + Prettier + Husky + Commitlint
- Zod validation utilities
- Error sanitization helpers

### Create a Backend Monorepo (Turborepo)

```bash
cd backend
./claude_tools/init-monorepo.sh my-platform
cd my-platform
npm run build
```

This creates:
- npm workspaces + Turborepo setup
- Shared utilities package
- Example package to copy/modify
- Parallel builds and caching

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

## Deployment

### Frontend (Cloudflare Pages)

Deploy any Quasar SPA to Cloudflare Pages:

```bash
# Build the SPA
npx quasar build

# Deploy to Cloudflare Pages
npx wrangler pages deploy dist/spa --project-name=my-app
```

For SPA routing to work, create `public/_redirects`:

```
/*    /index.html   200
```

### Backend (Cloudflare Workers)

Deploy workers directly:

```bash
npx wrangler deploy
```

Or for monorepos:

```bash
npm run deploy -w packages/my-worker
```

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
