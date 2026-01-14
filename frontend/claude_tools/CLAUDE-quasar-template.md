# Project: [Your Project Name]

## Overview
[2-3 sentence description of your application]

## Tech Stack
- **Framework**: Vue 3 with Composition API (`<script setup>`) + TypeScript
- **UI Framework**: Quasar v2 (Material Design components)
- **Build Tool**: Vite via @quasar/app-vite
- **State Management**: Pinia
- **Routing**: Vue Router 4
- **Unit Testing**: Vitest + @vue/test-utils
- **E2E Testing**: Playwright
- **Code Quality**: ESLint + Prettier + TypeScript strict mode

## Commands
```bash
# Development
quasar dev                    # Dev server at localhost:9000
npm run test:unit             # Run Vitest
npm run test:unit:ui          # Vitest with browser UI
npm run test:e2e              # Playwright E2E tests
npm run lint:fix              # Auto-fix lint issues
npm run type-check            # TypeScript validation
quasar build                  # Production build
```

## Project Structure
```
src/
├── components/               # Reusable UI components
│   └── __tests__/            # Colocated unit tests
├── pages/                    # Route page components
├── layouts/                  # Quasar layouts (MainLayout.vue)
├── composables/              # Vue composables (use*.ts)
├── stores/                   # Pinia stores
├── router/                   # Vue Router configuration
├── boot/                     # Quasar boot files (axios, i18n, etc.)
├── css/                      # Global styles
│   └── quasar.variables.scss # Quasar theme variables
└── types/                    # TypeScript type definitions
```

## Code Conventions

### Vue Components
- **ALWAYS** use `<script setup lang="ts">` syntax
- Props: `defineProps<{ prop: Type }>()`
- Emits: `defineEmits<{ (e: 'event', payload: Type): void }>()`
- Use Quasar components (Q*) over raw HTML elements

### TypeScript
- Strict mode enabled - no `any` types
- Define interfaces for all data structures
- Use type imports: `import type { Interface } from './types'`

### Naming
- Files: `kebab-case.vue`, `kebab-case.ts`
- Components: `PascalCase`
- Composables: `useCamelCase`
- Stores: `useCamelCaseStore`
- Tests: `*.spec.ts`

## ⚠️ MANDATORY: Test-Driven Development

**ALWAYS follow TDD - this is non-negotiable:**

1. **RED**: Write failing tests FIRST
2. **GREEN**: Write minimal code to pass
3. **REFACTOR**: Clean up while tests stay green

### Test File Template
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

  it('should [expected behavior]', async () => {
    // Arrange
    const wrapper = mount(ComponentName, { props: {} })
    
    // Act
    await wrapper.find('[data-testid="action"]').trigger('click')
    
    // Assert
    expect(wrapper.emitted('eventName')).toBeTruthy()
  })
})
```

## Component Template
```vue
<template>
  <div class="component-name">
    <q-card>
      <q-card-section>
        <!-- Content using Quasar components -->
      </q-card-section>
    </q-card>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

interface Props {
  title: string
  items?: string[]
}

const props = withDefaults(defineProps<Props>(), {
  items: () => []
})

const emit = defineEmits<{
  (e: 'select', item: string): void
  (e: 'close'): void
}>()

// Composables
const loading = ref(false)

// Computed
const hasItems = computed(() => props.items.length > 0)

// Methods
const handleSelect = (item: string) => {
  emit('select', item)
}
</script>

<style lang="scss" scoped>
.component-name {
  // Component-specific styles
}
</style>
```

## API Integration
- Base URL: `process.env.API_BASE_URL` or `/api`
- Use Axios configured in `src/boot/axios.ts`
- Handle errors globally with interceptors
- Use Pinia stores for API state management

## Quasar-Specific Notes
- ⚠️ `QPage` MUST be inside `QLayout`
- ⚠️ Always use `installQuasarPlugin()` in tests
- ⚠️ Quasar components have UIDs - add `for` attr for stable snapshots
- Use `$q.platform` for device detection
- Use `$q.dialog` and `$q.notify` for modals/toasts

## MCP Server Usage

The following MCP servers are available for autonomous development:

| Server | Purpose |
|--------|---------|
| `context7` | Real-time Vue/Quasar/Pinia/Vitest documentation |
| `playwright` | Browser automation, screenshots, visual testing |
| `chrome-devtools` | Console logs, network requests, DOM debugging |
| `figma` | Design import, tokens, component specs |
| `axe-accessibility` | WCAG compliance, accessibility audits |

### Context7 (Documentation)
```
"use context7 to check QTable slot documentation"
"use context7 for Pinia composable patterns"
"use context7 for Vue 3 Composition API patterns"
```

### Playwright (Browser Automation)
```
"use playwright to navigate to localhost:9000"
"use playwright to take a screenshot"
"use playwright to test at mobile viewport (375x667)"
```

### Chrome DevTools (Debugging)
```
"use chrome-devtools to check for console errors"
"use chrome-devtools to monitor network requests"
```
**Note:** Requires Chrome running with `--remote-debugging-port=9222`

### Figma (Design Input)
```
"use figma to read component specs from [URL]"
"use figma to extract design tokens"
```

### Axe Accessibility (A11y)
```
"use axe-accessibility to scan localhost:9000 for WCAG issues"
"use axe-accessibility to check color contrast"
```

### Autonomous Workflow
```
1. DESIGN → Read Figma designs
2. DOCS   → Fetch docs via Context7
3. CODE   → Implement with TDD
4. VIEW   → Screenshot via Playwright
5. DEBUG  → Check console via DevTools
6. A11Y   → Audit via Axe
7. COMMIT → When all checks pass
```

## Git Workflow
- Branches: `feature/`, `fix/`, `refactor/`, `test/`
- Commits: `type(scope): description`
  - Types: feat, fix, refactor, test, docs, chore
- Always run `npm run quality` before committing

## Quality Checklist (Auto-run via hooks)
- [ ] TypeScript compiles without errors
- [ ] ESLint passes (auto-fixed)
- [ ] All tests pass
- [ ] No console.log statements
- [ ] Props and emits properly typed

## Common Patterns

### Creating New Feature
1. Write tests in `__tests__/` folder
2. Run tests - confirm failure
3. Implement component/composable
4. Run tests until passing
5. Refactor if needed

### Pinia Store Template
```typescript
// src/stores/use-example-store.ts
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useExampleStore = defineStore('example', () => {
  // State
  const items = ref<Item[]>([])
  const loading = ref(false)

  // Getters
  const itemCount = computed(() => items.value.length)

  // Actions
  const fetchItems = async () => {
    loading.value = true
    try {
      // API call
    } finally {
      loading.value = false
    }
  }

  return { items, loading, itemCount, fetchItems }
})
```

### Composable Template
```typescript
// src/composables/use-example.ts
import { ref, computed, onMounted } from 'vue'

export function useExample(initialValue: string) {
  const value = ref(initialValue)
  const doubled = computed(() => value.value + value.value)

  const update = (newValue: string) => {
    value.value = newValue
  }

  onMounted(() => {
    // Setup logic
  })

  return { value, doubled, update }
}
```

## Environment Variables
```env
API_BASE_URL=http://localhost:3000/api
# Add your environment variables here
```

## Deployment
- Build: `quasar build`
- Output: `dist/spa/` (or appropriate mode)
- [Add deployment instructions]
