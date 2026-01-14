# Optimized Vue.js + Quasar Frontend Development Workflow with Claude Code

## Executive Summary

This guide provides a complete, automated workflow for developing Vue.js applications with the Quasar framework using Claude Code. The goal is to minimize manual input while maximizing quality through test-driven development, automated quality checks, and intelligent documentation fetching.

---

## Part 1: Project Foundation

### 1.1 Initial Project Setup

```bash
# Create new Quasar project with Vite (recommended)
npm init quasar

# Select options:
# - Quasar v2
# - Vite as build tool
# - TypeScript
# - Pinia for state management
# - Vue Router
# - ESLint + Prettier
# - Vitest for unit testing
# - Cypress or Playwright for E2E
```

### 1.2 Install Testing Extensions

```bash
cd your-quasar-project

# Add Vitest testing harness
quasar ext add @quasar/testing-unit-vitest

# Add E2E testing (choose one)
quasar ext add @quasar/testing-e2e-cypress
# OR for Playwright integration
npm install -D @playwright/test playwright
```

---

## Part 2: Claude Code Configuration

### 2.1 CLAUDE.md - Your Project Brain

Create a comprehensive `CLAUDE.md` file in your project root. This is the single most important configuration for minimizing your input.

```markdown
# Project: [Your App Name]

## Overview
[Brief description - 2-3 sentences about what this app does]

## Tech Stack
- **Framework**: Vue 3 with Composition API + TypeScript
- **UI Framework**: Quasar v2
- **Build Tool**: Vite
- **State Management**: Pinia
- **Routing**: Vue Router
- **Testing**: Vitest (unit), Playwright/Cypress (E2E)
- **Styling**: Quasar components + SCSS variables

## Critical Commands
```bash
# Development
quasar dev                    # Start dev server (localhost:9000)
npm run test:unit             # Run Vitest unit tests
npm run test:unit:ui          # Run Vitest with UI
npm run test:e2e              # Run E2E tests
npm run lint                  # ESLint + Prettier check
npm run lint:fix              # Auto-fix lint issues
quasar build                  # Production build
```

## Project Structure
```
src/
├── components/          # Reusable Vue components
│   └── __tests__/       # Component tests (colocated)
├── pages/               # Route page components
├── layouts/             # Quasar layout components
├── composables/         # Vue composables (use*.ts)
├── stores/              # Pinia stores
├── router/              # Vue Router config
├── boot/                # Quasar boot files
├── css/                 # Global styles & variables
│   └── quasar.variables.scss
└── types/               # TypeScript definitions
```

## Code Conventions

### Vue Components
- Use `<script setup lang="ts">` syntax exclusively
- Props: Use `defineProps<{...}>()` with TypeScript interfaces
- Emits: Use `defineEmits<{...}>()` with typed events
- Composables: Prefix with `use` (e.g., `useUserData`)
- Component names: PascalCase, descriptive (e.g., `UserProfileCard.vue`)

### Quasar Specifics
- Use Quasar components (Q*) instead of raw HTML where possible
- Leverage Quasar's built-in responsive classes
- Use `$q` global object for platform detection, dialogs, notifications
- Follow Quasar's slot naming conventions

### TypeScript
- Strict mode enabled
- No `any` types - define proper interfaces
- Use `defineComponent` for complex components if needed

### Testing Requirements
- **MANDATORY**: Write tests BEFORE implementation (TDD)
- Unit tests: Vitest + @vue/test-utils + installQuasarPlugin
- Component tests colocated in `__tests__/` folders
- E2E tests for critical user flows
- Minimum 80% code coverage target

### Naming Conventions
- Files: kebab-case (e.g., `user-profile.vue`)
- Components: PascalCase
- Composables: camelCase with `use` prefix
- Stores: camelCase with `use` prefix and `Store` suffix
- Tests: `*.spec.ts` or `*.test.ts`

## TDD Workflow (ALWAYS FOLLOW)
1. **RED**: Write failing test first
2. **GREEN**: Write minimal code to pass
3. **REFACTOR**: Clean up while tests pass
4. **NEVER** write implementation before tests

## API Integration
- Base URL: [Your API URL]
- Authentication: [JWT/OAuth/etc.]
- Use Axios via Quasar's boot file
- Handle errors globally in boot/axios.ts

## Environment Variables
- API_BASE_URL: Backend API endpoint
- [Add your env vars]

## Git Workflow
- Branch naming: `feature/`, `fix/`, `refactor/`
- Commit format: `type(scope): description`
- Run tests before committing

## Common Patterns

### Creating a New Component
1. Write component test first
2. Create component file
3. Implement to pass tests
4. Add to parent component
5. Run full test suite

### Creating a New Page
1. Define route in router/routes.ts
2. Write E2E test for user flow
3. Create page component
4. Implement features with unit tests
5. Verify E2E tests pass

## Warnings
- ⚠️ QLayout must wrap QPage components
- ⚠️ Always use `installQuasarPlugin()` in tests
- ⚠️ Quasar components generate UIDs - use `for` attribute for stable snapshots
- ⚠️ Don't use `any` in TypeScript
```

### 2.2 Directory-Specific CLAUDE.md Files

Create additional context files for complex directories:

**`src/components/CLAUDE.md`**
```markdown
# Components Directory

## Component Template
All components should follow this structure:

```vue
<template>
  <div class="component-name">
    <!-- Use Quasar components -->
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

interface Props {
  // Define props with types
}

const props = defineProps<Props>()
const emit = defineEmits<{
  (e: 'update', value: string): void
}>()
</script>

<style lang="scss" scoped>
.component-name {
  // Component styles
}
</style>
```

## Test Template
```typescript
import { installQuasarPlugin } from '@quasar/quasar-app-extension-testing-unit-vitest'
import { mount } from '@vue/test-utils'
import { describe, it, expect } from 'vitest'
import ComponentName from '../ComponentName.vue'

installQuasarPlugin()

describe('ComponentName', () => {
  it('should mount correctly', () => {
    const wrapper = mount(ComponentName, {
      props: { /* required props */ }
    })
    expect(wrapper.exists()).toBe(true)
  })
})
```
```

---

## Part 3: MCP Server Configuration

### 3.1 Essential MCP Servers

Add these MCP servers to your Claude Code configuration for maximum automation:

```bash
# Context7 - Real-time documentation fetching (HIGHLY RECOMMENDED)
claude mcp add context7 -- npx -y @upstash/context7-mcp

# Playwright MCP - Browser automation for visual testing
claude mcp add playwright -- npx -y @playwright/mcp@latest

# Alternatively, ExecuteAutomation's Playwright MCP (more features)
claude mcp add playwright -- npx -y @executeautomation/playwright-mcp-server
```

**Full MCP Configuration (`~/.claude.json` or project `.mcp.json`)**:

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"]
    },
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp@latest"]
    }
  }
}
```

### 3.2 Using Context7 for Documentation

Add this to your CLAUDE.md to auto-invoke:

```markdown
## AI Instructions
Always use Context7 MCP to fetch current documentation when:
- Working with Vue 3 Composition API
- Using Quasar components
- Implementing Pinia stores
- Writing Vitest tests
- Configuring Vite

Usage: Include "use context7" when asking about framework features.
```

---

## Part 4: Automated Hooks Configuration

### 4.1 Project Hooks Setup

Create `.claude/settings.json` in your project root:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit:*.vue|Edit:*.ts|Write:*.vue|Write:*.ts",
        "hooks": [
          {
            "type": "command",
            "command": "npm run lint:fix -- --quiet"
          }
        ]
      },
      {
        "matcher": "Edit:*.spec.ts|Edit:*.test.ts|Write:*.spec.ts|Write:*.test.ts",
        "hooks": [
          {
            "type": "command",
            "command": "npm run test:unit -- --run --reporter=verbose"
          }
        ]
      }
    ],
    "Stop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/end-of-turn.sh"
          }
        ]
      }
    ]
  }
}
```

### 4.2 End-of-Turn Hook Script

Create `.claude/hooks/end-of-turn.sh`:

```bash
#!/bin/bash
set -e

echo "🔄 Running end-of-turn quality checks..."

# Type checking
echo "📝 TypeScript check..."
npx vue-tsc --noEmit || { echo "❌ TypeScript errors"; exit 2; }

# Linting
echo "🔍 Lint check..."
npm run lint -- --quiet || { echo "❌ Lint errors"; exit 2; }

# Run affected tests
echo "🧪 Running tests..."
npm run test:unit -- --run --passWithNoTests || { echo "❌ Test failures"; exit 2; }

echo "✅ All quality checks passed!"
```

Make it executable:
```bash
chmod +x .claude/hooks/end-of-turn.sh
```

---

## Part 5: Custom Slash Commands

### 5.1 TDD Component Creation

Create `.claude/commands/create-component.md`:

```markdown
---
description: Create a new Vue/Quasar component using TDD
---

# Create Component: $ARGUMENTS

Follow these steps STRICTLY in order:

## Phase 1: RED (Write Failing Tests)
1. Create test file at `src/components/__tests__/$ARGUMENTS.spec.ts`
2. Write comprehensive tests covering:
   - Component mounting
   - Props validation
   - Event emissions
   - User interactions
   - Edge cases
3. Use `installQuasarPlugin()` from '@quasar/quasar-app-extension-testing-unit-vitest'
4. Run tests - confirm they FAIL
5. DO NOT write any implementation yet

## Phase 2: GREEN (Minimal Implementation)
1. Create component at `src/components/$ARGUMENTS.vue`
2. Write ONLY enough code to make tests pass
3. Run tests after each small change
4. Stop when all tests pass

## Phase 3: REFACTOR
1. Clean up code while keeping tests green
2. Extract reusable logic to composables if needed
3. Ensure proper TypeScript types
4. Run final test suite

## Requirements
- Use `<script setup lang="ts">` syntax
- Use Quasar components where appropriate
- Follow project naming conventions
- Maintain test coverage
```

### 5.2 Create Page with E2E Tests

Create `.claude/commands/create-page.md`:

```markdown
---
description: Create a new page with route and E2E tests
---

# Create Page: $ARGUMENTS

## Step 1: Define Route
Add route to `src/router/routes.ts`

## Step 2: Write E2E Test (Using Playwright MCP)
1. Create E2E test file
2. Define user journey
3. Use Playwright MCP to validate UI behavior

## Step 3: Create Page Component
1. Create page in `src/pages/`
2. Use QPage wrapped in layout
3. Implement to pass E2E tests

## Step 4: Add Unit Tests
Write unit tests for page logic/composables
```

### 5.3 Visual Testing Command

Create `.claude/commands/visual-test.md`:

```markdown
---
description: Visually test a component or page using Playwright MCP
---

# Visual Test: $ARGUMENTS

Use the Playwright MCP to:

1. Start the dev server if not running: `quasar dev`
2. Navigate to the component/page
3. Take screenshots at different viewport sizes:
   - Mobile: 375x667
   - Tablet: 768x1024
   - Desktop: 1920x1080
4. Interact with the UI elements
5. Verify visual appearance
6. Report any issues found

If issues are found, propose fixes and verify with another visual test.
```

---

## Part 6: Testing Configuration

### 6.1 Vitest Configuration

Create/update `vitest.config.mts`:

```typescript
import { defineConfig } from 'vitest/config'
import vue from '@vitejs/plugin-vue'
import { quasar, transformAssetUrls } from '@quasar/vite-plugin'
import tsconfigPaths from 'vite-tsconfig-paths'

export default defineConfig({
  plugins: [
    tsconfigPaths(),
    vue({
      template: { transformAssetUrls }
    }),
    quasar({
      sassVariables: 'src/css/quasar.variables.scss'
    })
  ],
  test: {
    environment: 'jsdom',
    globals: true,
    include: ['src/**/*.{test,spec}.{js,ts}'],
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      exclude: [
        'node_modules/',
        'src/**/*.d.ts',
        'src/boot/',
        'src/router/'
      ],
      thresholds: {
        statements: 80,
        branches: 80,
        functions: 80,
        lines: 80
      }
    },
    setupFiles: ['./test/vitest-setup.ts']
  }
})
```

### 6.2 Test Setup File

Create `test/vitest-setup.ts`:

```typescript
import { config } from '@vue/test-utils'
import { Quasar } from 'quasar'

// Global Quasar installation for all tests
config.global.plugins.push([Quasar, {}])

// Mock IntersectionObserver
class MockIntersectionObserver {
  observe = vi.fn()
  disconnect = vi.fn()
  unobserve = vi.fn()
}

Object.defineProperty(window, 'IntersectionObserver', {
  writable: true,
  value: MockIntersectionObserver
})

// Mock ResizeObserver
class MockResizeObserver {
  observe = vi.fn()
  disconnect = vi.fn()
  unobserve = vi.fn()
}

Object.defineProperty(window, 'ResizeObserver', {
  writable: true,
  value: MockResizeObserver
})
```

### 6.3 Example Component Test

```typescript
// src/components/__tests__/UserCard.spec.ts
import { installQuasarPlugin } from '@quasar/quasar-app-extension-testing-unit-vitest'
import { mount } from '@vue/test-utils'
import { describe, it, expect, vi } from 'vitest'
import UserCard from '../UserCard.vue'

installQuasarPlugin()

describe('UserCard', () => {
  const defaultProps = {
    user: {
      id: 1,
      name: 'John Doe',
      email: 'john@example.com',
      avatar: 'https://example.com/avatar.jpg'
    }
  }

  it('renders user information correctly', () => {
    const wrapper = mount(UserCard, { props: defaultProps })
    
    expect(wrapper.text()).toContain('John Doe')
    expect(wrapper.text()).toContain('john@example.com')
  })

  it('emits edit event when edit button clicked', async () => {
    const wrapper = mount(UserCard, { props: defaultProps })
    
    await wrapper.find('[data-testid="edit-btn"]').trigger('click')
    
    expect(wrapper.emitted('edit')).toBeTruthy()
    expect(wrapper.emitted('edit')![0]).toEqual([defaultProps.user])
  })

  it('displays placeholder when no avatar provided', () => {
    const wrapper = mount(UserCard, {
      props: {
        user: { ...defaultProps.user, avatar: undefined }
      }
    })
    
    expect(wrapper.find('[data-testid="avatar-placeholder"]').exists()).toBe(true)
  })
})
```

---

## Part 7: Workflow Automation

### 7.1 Package.json Scripts

Add these scripts to your `package.json`:

```json
{
  "scripts": {
    "dev": "quasar dev",
    "build": "quasar build",
    "lint": "eslint --ext .js,.ts,.vue ./src",
    "lint:fix": "eslint --ext .js,.ts,.vue ./src --fix",
    "format": "prettier --write \"src/**/*.{js,ts,vue,scss,md}\"",
    "test:unit": "vitest",
    "test:unit:ui": "vitest --ui",
    "test:unit:run": "vitest run",
    "test:unit:coverage": "vitest run --coverage",
    "test:e2e": "playwright test",
    "test:e2e:ui": "playwright test --ui",
    "test:all": "npm run test:unit:run && npm run test:e2e",
    "type-check": "vue-tsc --noEmit",
    "quality": "npm run type-check && npm run lint && npm run test:unit:run"
  }
}
```

### 7.2 Running Claude Code Optimally

Start Claude Code with optimal settings:

```bash
# For maximum autonomy (use in trusted projects)
claude --dangerously-skip-permissions

# For standard use
claude

# With specific model for complex tasks
claude --model claude-sonnet-4-5-20250929
```

---

## Part 8: Example Workflow Session

### Starting a New Feature

```
You: Create a UserProfile component that displays user information with edit capability

Claude will automatically:
1. Read CLAUDE.md for project context
2. Fetch Vue 3 & Quasar docs via Context7
3. Create test file first (TDD)
4. Run tests (should fail)
5. Create component implementation
6. Run tests until passing
7. PostToolUse hooks run lint:fix
8. Stop hook runs full quality checks
9. Report completion with test coverage
```

### Visual Verification

```
You: /visual-test UserProfile component

Claude will:
1. Use Playwright MCP to open browser
2. Navigate to component
3. Test at multiple viewports
4. Interact with elements
5. Report visual issues
6. Fix if needed
```

---

## Part 9: TDD Subagents (Advanced)

For strict TDD enforcement, create specialized subagents:

### 9.1 Test Writer Subagent

Create `.claude/agents/tdd-test-writer.md`:

```markdown
---
name: tdd-test-writer
description: Writes failing tests for new features. Only writes tests, never implementation.
---

# TDD Test Writer

You are a specialized test-writing agent. Your ONLY job is to write comprehensive failing tests.

## Rules
1. NEVER write implementation code
2. NEVER suggest implementation approaches
3. ONLY output test files
4. Use @quasar/quasar-app-extension-testing-unit-vitest
5. Include all edge cases
6. Use data-testid attributes for selectors

## Output Format
Return ONLY the test file content, nothing else.
```

### 9.2 Implementer Subagent

Create `.claude/agents/tdd-implementer.md`:

```markdown
---
name: tdd-implementer
description: Implements minimal code to make tests pass. Only writes implementation.
---

# TDD Implementer

You implement the minimum code needed to make failing tests pass.

## Rules
1. NEVER modify test files
2. Write MINIMAL code to pass tests
3. Don't add features not covered by tests
4. Run tests after each change
5. Stop when tests pass

## Process
1. Read failing test file
2. Understand requirements from tests
3. Write minimal implementation
4. Run tests
5. Iterate until green
```

---

## Part 10: Quick Reference

### Essential Commands

| Command | Purpose |
|---------|---------|
| `/create-component ComponentName` | TDD component creation |
| `/create-page PageName` | Create page with E2E |
| `/visual-test target` | Visual browser testing |
| `/init` | Initialize CLAUDE.md |
| `/hooks` | Configure hooks |
| `/mcp` | View MCP servers |

### Key Prompts

```
"Create [feature] using TDD - write tests first"
"Use context7 to check Quasar QTable documentation"
"Use playwright mcp to visually verify the login page"
"Run the full test suite and fix any failures"
"Refactor [component] while maintaining test coverage"
```

### Troubleshooting

| Issue | Solution |
|-------|----------|
| Tests not finding Quasar components | Add `installQuasarPlugin()` |
| QPage errors in tests | Wrap in QLayout mock |
| Snapshot UID issues | Add `for` attribute or stub component |
| Context7 not fetching docs | Include "use context7" in prompt |
| Playwright not opening | Check MCP connection with `/mcp` |

---

## Conclusion

This workflow provides:

1. **Minimal Input**: CLAUDE.md provides persistent context, hooks automate quality checks
2. **TDD Enforcement**: Custom commands and subagents ensure test-first development
3. **Real-time Docs**: Context7 MCP eliminates outdated API usage
4. **Visual Verification**: Playwright MCP enables browser-based testing
5. **Automated Quality**: Hooks run linting, type-checking, and tests automatically

The key to success is a well-configured CLAUDE.md file and properly set up hooks. Once configured, you can focus on specifications and direction while Claude Code handles the implementation details.
