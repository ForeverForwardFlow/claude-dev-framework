# Vue 3 + Quasar Framework Project

## Overview
<!-- UPDATE FOR EACH PROJECT -->
This is a Vue 3 application built with the Quasar Framework. Update this section with your specific project description.

## Tech Stack
- **Framework**: Vue 3 with Composition API (`<script setup lang="ts">`)
- **UI Framework**: Quasar v2 (Material Design components)
- **Build Tool**: Vite via @quasar/app-vite
- **State Management**: Pinia
- **Routing**: Vue Router 4
- **Unit Testing**: Vitest + @vue/test-utils + @quasar/quasar-app-extension-testing-unit-vitest
- **E2E Testing**: Playwright
- **Language**: TypeScript (strict mode)
- **Linting**: ESLint with Vue, TypeScript, and Prettier plugins
- **Formatting**: Prettier
- **Git Hooks**: Husky + lint-staged + commitlint

## Build Targets
This project supports all Quasar build modes:
- **SPA**: `quasar build` - Single Page Application
- **PWA**: `quasar build -m pwa` - Progressive Web App
- **SSR**: `quasar build -m ssr` - Server-Side Rendering
- **Electron**: `quasar build -m electron` - Desktop App
- **Cordova**: `quasar build -m cordova` - Mobile App (iOS/Android)
- **Capacitor**: `quasar build -m capacitor` - Mobile App (iOS/Android)
- **BEX**: `quasar build -m bex` - Browser Extension

## Commands
```bash
# Development
quasar dev                        # SPA dev server (localhost:9000)
quasar dev -m pwa                 # PWA dev mode
quasar dev -m ssr                 # SSR dev mode
quasar dev -m electron            # Electron dev mode
quasar dev -m capacitor -T ios    # Capacitor iOS
quasar dev -m capacitor -T android # Capacitor Android

# Testing
npm run test:unit                 # Run Vitest in watch mode
npm run test:unit:run             # Run Vitest once
npm run test:unit:ui              # Vitest with browser UI
npm run test:unit:coverage        # Run with coverage report
npm run test:e2e                  # Run Playwright tests
npm run test:e2e:ui               # Playwright with UI mode
npm run test:e2e:headed           # Playwright in headed browser

# Code Quality
npm run lint                      # ESLint check
npm run lint:fix                  # ESLint auto-fix
npm run format                    # Prettier format all files
npm run format:check              # Prettier check (no write)
npm run type-check                # TypeScript validation
npm run quality                   # Run all checks (type + lint + test)

# Build
quasar build                      # Production SPA build
quasar build -m pwa               # Production PWA build

# Git Hooks (automatic via Husky)
# pre-commit: lint-staged (lint + format staged files)
# commit-msg: commitlint (enforce conventional commits)
# pre-push: run full test suite
```

## Project Structure
```
src/
├── assets/                  # Static assets (images, fonts)
├── boot/                    # Quasar boot files (axios, i18n, auth)
├── components/              # Reusable Vue components
│   ├── __tests__/           # Component unit tests (colocated)
│   └── [ComponentName].vue
├── composables/             # Vue composables (use*.ts)
│   └── __tests__/
├── css/                     # Global styles
│   ├── app.scss             # App-wide styles
│   └── quasar.variables.scss # Quasar theme customization
├── layouts/                 # Quasar layout components
│   └── MainLayout.vue
├── pages/                   # Route page components
│   └── __tests__/
├── router/                  # Vue Router configuration
│   ├── index.ts
│   └── routes.ts
├── stores/                  # Pinia stores
│   └── __tests__/
├── types/                   # TypeScript type definitions
│   └── index.ts
└── App.vue                  # Root component

test/
├── e2e/                     # Playwright E2E tests
│   ├── fixtures/
│   └── *.spec.ts
└── vitest-setup.ts          # Vitest global setup

# Config files (root)
├── .husky/                  # Git hooks
│   ├── pre-commit
│   ├── commit-msg
│   └── pre-push
├── .eslintrc.cjs            # ESLint configuration
├── .prettierrc              # Prettier configuration
├── .prettierignore          # Prettier ignore patterns
├── commitlint.config.cjs    # Commitlint configuration
├── lint-staged.config.cjs   # lint-staged configuration
├── vitest.config.mts        # Vitest configuration
├── playwright.config.ts     # Playwright configuration
├── tsconfig.json            # TypeScript configuration
└── quasar.config.ts         # Quasar configuration
```

---

## 🛠️ Tooling Configuration

### Package.json Scripts

```json
{
  "scripts": {
    "dev": "quasar dev",
    "build": "quasar build",
    "lint": "eslint --ext .js,.ts,.vue ./src",
    "lint:fix": "eslint --ext .js,.ts,.vue ./src --fix",
    "format": "prettier --write \"src/**/*.{js,ts,vue,scss,css,json,md}\"",
    "format:check": "prettier --check \"src/**/*.{js,ts,vue,scss,css,json,md}\"",
    "type-check": "vue-tsc --noEmit",
    "test:unit": "vitest",
    "test:unit:run": "vitest run",
    "test:unit:ui": "vitest --ui",
    "test:unit:coverage": "vitest run --coverage",
    "test:e2e": "playwright test",
    "test:e2e:ui": "playwright test --ui",
    "test:e2e:headed": "playwright test --headed",
    "test:e2e:debug": "playwright test --debug",
    "quality": "npm run type-check && npm run lint && npm run test:unit:run",
    "prepare": "husky"
  }
}
```

### Package.json DevDependencies

```json
{
  "devDependencies": {
    "@commitlint/cli": "^19.0.0",
    "@commitlint/config-conventional": "^19.0.0",
    "@playwright/test": "^1.40.0",
    "@quasar/app-vite": "^2.0.0",
    "@quasar/quasar-app-extension-testing-unit-vitest": "^1.0.0",
    "@rushstack/eslint-patch": "^1.6.0",
    "@types/node": "^20.10.0",
    "@typescript-eslint/eslint-plugin": "^7.0.0",
    "@typescript-eslint/parser": "^7.0.0",
    "@vitejs/plugin-vue": "^5.0.0",
    "@vitest/coverage-v8": "^2.0.0",
    "@vitest/ui": "^2.0.0",
    "@vue/eslint-config-prettier": "^9.0.0",
    "@vue/eslint-config-typescript": "^13.0.0",
    "@vue/test-utils": "^2.4.0",
    "eslint": "^8.56.0",
    "eslint-plugin-vue": "^9.20.0",
    "husky": "^9.0.0",
    "jsdom": "^24.0.0",
    "lint-staged": "^15.2.0",
    "prettier": "^3.2.0",
    "typescript": "^5.3.0",
    "vite": "^5.0.0",
    "vitest": "^2.0.0",
    "vue-tsc": "^2.0.0"
  }
}
```

---

### ESLint Configuration

```javascript
// .eslintrc.cjs
/* eslint-env node */
require('@rushstack/eslint-patch/modern-module-resolution')

module.exports = {
  root: true,
  env: {
    browser: true,
    es2022: true,
    node: true
  },
  extends: [
    'plugin:vue/vue3-recommended',
    'eslint:recommended',
    '@vue/eslint-config-typescript',
    '@vue/eslint-config-prettier/skip-formatting'
  ],
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module'
  },
  plugins: ['@typescript-eslint'],
  rules: {
    // Vue specific
    'vue/multi-word-component-names': 'off', // Quasar pages often single word
    'vue/no-v-html': 'warn',
    'vue/component-tags-order': ['error', {
      order: ['template', 'script', 'style']
    }],
    'vue/block-lang': ['error', {
      script: { lang: 'ts' },
      style: { lang: 'scss' }
    }],
    'vue/define-macros-order': ['error', {
      order: ['defineProps', 'defineEmits']
    }],
    'vue/define-emits-declaration': ['error', 'type-based'],
    'vue/define-props-declaration': ['error', 'type-based'],
    'vue/no-unused-refs': 'error',
    'vue/no-useless-v-bind': 'error',
    'vue/padding-line-between-blocks': 'error',
    'vue/prefer-separate-static-class': 'error',
    'vue/prefer-true-attribute-shorthand': 'error',
    'vue/v-for-delimiter-style': ['error', 'in'],

    // TypeScript specific
    '@typescript-eslint/no-unused-vars': ['error', { 
      argsIgnorePattern: '^_',
      varsIgnorePattern: '^_'
    }],
    '@typescript-eslint/no-explicit-any': 'error',
    '@typescript-eslint/explicit-function-return-type': 'off',
    '@typescript-eslint/consistent-type-imports': ['error', {
      prefer: 'type-imports',
      fixStyle: 'separate-type-imports'
    }],
    '@typescript-eslint/no-import-type-side-effects': 'error',

    // General
    'no-console': ['warn', { allow: ['warn', 'error'] }],
    'no-debugger': 'warn',
    'prefer-const': 'error',
    'no-var': 'error',
    'object-shorthand': 'error',
    'prefer-template': 'error'
  },
  overrides: [
    {
      // Test files
      files: ['**/*.spec.ts', '**/*.test.ts', '**/test/**/*.ts'],
      rules: {
        '@typescript-eslint/no-explicit-any': 'off',
        'no-console': 'off'
      }
    },
    {
      // Config files
      files: ['*.config.ts', '*.config.js', '*.config.cjs', '*.config.mjs'],
      rules: {
        '@typescript-eslint/no-require-imports': 'off'
      }
    }
  ],
  ignorePatterns: [
    'dist',
    'node_modules',
    '.quasar',
    'src-capacitor',
    'src-cordova',
    'src-electron',
    'src-bex',
    'coverage',
    '*.d.ts'
  ]
}
```

---

### Prettier Configuration

```json
// .prettierrc
{
  "semi": false,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "none",
  "printWidth": 100,
  "bracketSpacing": true,
  "bracketSameLine": false,
  "arrowParens": "avoid",
  "endOfLine": "lf",
  "vueIndentScriptAndStyle": false,
  "singleAttributePerLine": false,
  "htmlWhitespaceSensitivity": "ignore"
}
```

```gitignore
// .prettierignore
dist
node_modules
.quasar
src-capacitor
src-cordova
src-electron
src-bex
coverage
*.min.js
*.min.css
package-lock.json
pnpm-lock.yaml
yarn.lock
```

---

### Husky Git Hooks Setup

**Installation** (run once per project):
```bash
npm install -D husky lint-staged @commitlint/cli @commitlint/config-conventional
npx husky init
```

**Pre-commit Hook** - `.husky/pre-commit`:
```bash
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

npx lint-staged
```

**Commit Message Hook** - `.husky/commit-msg`:
```bash
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

npx --no -- commitlint --edit "$1"
```

**Pre-push Hook** - `.husky/pre-push`:
```bash
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

echo "🧪 Running tests before push..."
npm run type-check && npm run test:unit:run

if [ $? -ne 0 ]; then
  echo "❌ Tests failed. Push aborted."
  exit 1
fi

echo "✅ All tests passed. Pushing..."
```

---

### lint-staged Configuration

```javascript
// lint-staged.config.cjs
module.exports = {
  // Vue files: lint + format
  '*.vue': [
    'eslint --fix',
    'prettier --write'
  ],
  // TypeScript files: lint + format
  '*.{ts,tsx}': [
    'eslint --fix',
    'prettier --write'
  ],
  // JavaScript files: lint + format  
  '*.{js,jsx,cjs,mjs}': [
    'eslint --fix',
    'prettier --write'
  ],
  // Style files: format only
  '*.{css,scss,sass}': [
    'prettier --write'
  ],
  // Other files: format only
  '*.{json,md,yaml,yml}': [
    'prettier --write'
  ]
}
```

---

### Commitlint Configuration

```javascript
// commitlint.config.cjs
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    // Type must be one of the following
    'type-enum': [
      2,
      'always',
      [
        'feat',     // New feature
        'fix',      // Bug fix
        'docs',     // Documentation only
        'style',    // Formatting, no code change
        'refactor', // Code change that neither fixes nor adds
        'perf',     // Performance improvement
        'test',     // Adding or fixing tests
        'chore',    // Maintenance tasks
        'ci',       // CI/CD changes
        'build',    // Build system changes
        'revert'    // Revert previous commit
      ]
    ],
    // Subject (description) rules
    'subject-case': [2, 'always', 'lower-case'],
    'subject-empty': [2, 'never'],
    'subject-max-length': [2, 'always', 72],
    // Type rules
    'type-case': [2, 'always', 'lower-case'],
    'type-empty': [2, 'never'],
    // Scope rules (optional but lowercase if present)
    'scope-case': [2, 'always', 'lower-case'],
    // Body rules
    'body-max-line-length': [2, 'always', 100],
    // Header rules
    'header-max-length': [2, 'always', 100]
  }
}
```

---

### Vitest Configuration

```typescript
// vitest.config.mts
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
    exclude: ['node_modules', 'dist', '.quasar'],
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html', 'lcov'],
      reportsDirectory: './coverage',
      exclude: [
        'node_modules/',
        'dist/',
        '.quasar/',
        'src/**/*.d.ts',
        'src/boot/',
        'src/router/index.ts',
        '**/*.config.*',
        '**/types/**'
      ],
      thresholds: {
        statements: 80,
        branches: 80,
        functions: 80,
        lines: 80
      }
    },
    setupFiles: ['./test/vitest-setup.ts'],
    reporters: ['default', 'html'],
    outputFile: {
      html: './test-results/index.html'
    }
  }
})
```

---

### Playwright Configuration

```typescript
// playwright.config.ts
import { defineConfig, devices } from '@playwright/test'

export default defineConfig({
  testDir: './test/e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [
    ['html', { outputFolder: 'playwright-report' }],
    ['list']
  ],
  use: {
    baseURL: 'http://localhost:9000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure'
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] }
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] }
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] }
    },
    // Mobile viewports
    {
      name: 'Mobile Chrome',
      use: { ...devices['Pixel 5'] }
    },
    {
      name: 'Mobile Safari',
      use: { ...devices['iPhone 12'] }
    }
  ],
  // Run dev server before tests
  webServer: {
    command: 'quasar dev',
    url: 'http://localhost:9000',
    reuseExistingServer: !process.env.CI,
    timeout: 120 * 1000
  }
})
```

---

### TypeScript Configuration

```json
// tsconfig.json
{
  "compilerOptions": {
    "target": "ESNext",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "lib": ["ESNext", "DOM", "DOM.Iterable"],
    "strict": true,
    "noEmit": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "useDefineForClassFields": true,
    "jsx": "preserve",
    "baseUrl": ".",
    "paths": {
      "src/*": ["src/*"],
      "components/*": ["src/components/*"],
      "composables/*": ["src/composables/*"],
      "stores/*": ["src/stores/*"],
      "types/*": ["src/types/*"]
    },
    "types": [
      "node",
      "vitest/globals",
      "@quasar/app-vite"
    ],
    // Strict type checking
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "strictBindCallApply": true,
    "strictPropertyInitialization": true,
    "noImplicitThis": true,
    "alwaysStrict": true,
    // Additional checks
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedIndexedAccess": true
  },
  "include": [
    "src/**/*.ts",
    "src/**/*.vue",
    "test/**/*.ts"
  ],
  "exclude": [
    "node_modules",
    "dist",
    ".quasar"
  ]
}
```

---

### EditorConfig

```ini
# .editorconfig
root = true

[*]
charset = utf-8
end_of_line = lf
indent_size = 2
indent_style = space
insert_final_newline = true
trim_trailing_whitespace = true
max_line_length = 100

[*.md]
trim_trailing_whitespace = false

[*.{yml,yaml}]
indent_size = 2

[Makefile]
indent_style = tab
```

---

### VS Code Settings (Recommended)

```json
// .vscode/settings.json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit",
    "source.organizeImports": "never"
  },
  "[vue]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "typescript.preferences.importModuleSpecifier": "relative",
  "typescript.tsdk": "node_modules/typescript/lib",
  "eslint.validate": [
    "javascript",
    "typescript",
    "vue"
  ],
  "files.associations": {
    "*.css": "scss"
  },
  "editor.quickSuggestions": {
    "strings": true
  }
}
```

```json
// .vscode/extensions.json
{
  "recommendations": [
    "Vue.volar",
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode",
    "EditorConfig.EditorConfig",
    "vitest.explorer",
    "ms-playwright.playwright"
  ]
}
```

---

## 🔴🟢🔵 TEST-DRIVEN DEVELOPMENT (MANDATORY)

**All new code MUST follow TDD. This is non-negotiable.**

### The TDD Cycle
1. **🔴 RED**: Write a failing test that defines expected behavior
2. **🟢 GREEN**: Write the minimal code to make the test pass
3. **🔵 REFACTOR**: Clean up code while keeping tests green

### TDD Rules
- NEVER write implementation code before writing tests
- Each test should test ONE thing
- Tests are documentation - write them clearly
- Run tests after every change
- Commit failing tests before implementing (optional but recommended)

### When to Write Which Tests
| Scenario | Test Type |
|----------|-----------|
| Component logic, props, emits | Unit test (Vitest) |
| Composable functions | Unit test (Vitest) |
| Pinia store actions/getters | Unit test (Vitest) |
| User flows, navigation, forms | E2E test (Playwright) |
| Visual appearance verification | E2E test (Playwright) |
| API integration | E2E test (Playwright) or MSW mocking |

---

## Code Conventions

### Vue Components

**File Structure** (in this exact order):
```vue
<template>
  <!-- Template first -->
</template>

<script setup lang="ts">
// Script second
</script>

<style lang="scss" scoped>
// Styles last, always scoped
</style>
```

**Script Setup Pattern**:
```vue
<script setup lang="ts">
// 1. Type imports
import type { PropType } from 'vue'

// 2. Component/external imports
import { ref, computed, onMounted } from 'vue'
import { useQuasar } from 'quasar'
import { useRouter } from 'vue-router'

// 3. Composable imports
import { useExample } from 'src/composables/use-example'

// 4. Props definition
interface Props {
  title: string
  items?: string[]
  disabled?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  items: () => [],
  disabled: false
})

// 5. Emits definition
const emit = defineEmits<{
  (e: 'select', item: string): void
  (e: 'update:modelValue', value: string): void
  (e: 'close'): void
}>()

// 6. Composables & injections
const $q = useQuasar()
const router = useRouter()
const { data, loading } = useExample()

// 7. Reactive state
const internalValue = ref('')
const isOpen = ref(false)

// 8. Computed properties
const hasItems = computed(() => props.items.length > 0)
const isDisabled = computed(() => props.disabled || loading.value)

// 9. Methods
const handleSelect = (item: string) => {
  emit('select', item)
}

const showNotification = (message: string) => {
  $q.notify({ message, type: 'positive' })
}

// 10. Lifecycle hooks
onMounted(() => {
  // Initialization logic
})

// 11. Expose (if needed)
defineExpose({ internalValue })
</script>
```

### TypeScript

**Strict Rules**:
- ❌ NEVER use `any` - always define proper types
- ❌ NEVER use `@ts-ignore` or `@ts-nocheck`
- ✅ Use `unknown` when type is truly unknown, then narrow
- ✅ Use type imports: `import type { X } from 'y'`
- ✅ Define interfaces for all data structures
- ✅ Use generics for reusable types

**Type Definition Patterns**:
```typescript
// src/types/index.ts

// API Response types
export interface ApiResponse<T> {
  data: T
  message: string
  success: boolean
}

// Entity types
export interface User {
  id: number
  email: string
  name: string
  avatar?: string
  createdAt: string
}

// Form types
export interface LoginForm {
  email: string
  password: string
  rememberMe: boolean
}

// Component prop types (can also be inline)
export interface TableColumn {
  name: string
  label: string
  field: string | ((row: unknown) => unknown)
  sortable?: boolean
  align?: 'left' | 'center' | 'right'
}
```

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Files (components) | PascalCase | `UserProfileCard.vue` |
| Files (composables) | kebab-case with use- | `use-auth.ts` |
| Files (stores) | kebab-case | `user-store.ts` |
| Files (types) | kebab-case | `api-types.ts` |
| Files (tests) | same as source + .spec | `UserCard.spec.ts` |
| Components | PascalCase | `<UserProfileCard />` |
| Composables | camelCase with use | `useAuth()` |
| Pinia Stores | camelCase with use + Store | `useUserStore()` |
| Props | camelCase | `userName`, `isDisabled` |
| Events | kebab-case | `@update-value`, `@item-selected` |
| CSS classes | kebab-case | `.user-card`, `.is-active` |
| Constants | SCREAMING_SNAKE | `MAX_RETRIES`, `API_TIMEOUT` |

### Quasar Component Usage

**Always prefer Quasar components over raw HTML**:
```vue
<!-- ❌ Don't do this -->
<button @click="submit">Submit</button>
<input v-model="email" type="email" />

<!-- ✅ Do this -->
<q-btn @click="submit" label="Submit" color="primary" />
<q-input v-model="email" type="email" label="Email" />
```

**Use Quasar's utility classes for styling**:
```vue
<!-- ❌ Don't write custom CSS for common patterns -->
<div style="display: flex; justify-content: space-between;">

<!-- ✅ Use Quasar classes -->
<div class="row justify-between">
<div class="q-pa-md q-mt-lg">
<div class="text-h6 text-weight-bold text-primary">
```

**Common Quasar Classes**:
- Spacing: `q-pa-{xs|sm|md|lg|xl}`, `q-ma-*`, `q-pt-*`, `q-mr-*`
- Flexbox: `row`, `column`, `justify-center`, `items-center`, `flex-center`
- Typography: `text-h1` to `text-h6`, `text-body1`, `text-caption`
- Colors: `text-primary`, `bg-secondary`, `text-negative`
- Visibility: `gt-sm` (greater than sm), `lt-md` (less than md)

---

## Testing

### Vitest Setup File

```typescript
// test/vitest-setup.ts
import { config } from '@vue/test-utils'
import { Quasar } from 'quasar'
import { vi } from 'vitest'

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

// Mock matchMedia
Object.defineProperty(window, 'matchMedia', {
  writable: true,
  value: vi.fn().mockImplementation(query => ({
    matches: false,
    media: query,
    onchange: null,
    addListener: vi.fn(),
    removeListener: vi.fn(),
    addEventListener: vi.fn(),
    removeEventListener: vi.fn(),
    dispatchEvent: vi.fn()
  }))
})

// Mock scrollTo
window.scrollTo = vi.fn()
```

### Unit Test Template (Vitest)

```typescript
// src/components/__tests__/ExampleComponent.spec.ts
import { installQuasarPlugin } from '@quasar/quasar-app-extension-testing-unit-vitest'
import { mount, VueWrapper } from '@vue/test-utils'
import { describe, it, expect, beforeEach, vi } from 'vitest'
import ExampleComponent from '../ExampleComponent.vue'

// Install Quasar plugin for all tests in this file
installQuasarPlugin()

describe('ExampleComponent', () => {
  let wrapper: VueWrapper

  // Default props for reuse
  const defaultProps = {
    title: 'Test Title',
    items: ['Item 1', 'Item 2']
  }

  // Helper to create wrapper with custom props
  const createWrapper = (props = {}) => {
    return mount(ExampleComponent, {
      props: { ...defaultProps, ...props }
    })
  }

  beforeEach(() => {
    wrapper = createWrapper()
  })

  describe('rendering', () => {
    it('should mount successfully', () => {
      expect(wrapper.exists()).toBe(true)
    })

    it('should display title from props', () => {
      expect(wrapper.text()).toContain('Test Title')
    })

    it('should render all items', () => {
      const items = wrapper.findAll('[data-testid="list-item"]')
      expect(items).toHaveLength(2)
    })
  })

  describe('props', () => {
    it('should apply disabled state when disabled prop is true', () => {
      wrapper = createWrapper({ disabled: true })
      expect(wrapper.find('[data-testid="action-btn"]').attributes('disabled')).toBeDefined()
    })
  })

  describe('events', () => {
    it('should emit select event when item is clicked', async () => {
      await wrapper.find('[data-testid="list-item"]').trigger('click')
      
      expect(wrapper.emitted('select')).toBeTruthy()
      expect(wrapper.emitted('select')![0]).toEqual(['Item 1'])
    })

    it('should emit close event when close button clicked', async () => {
      await wrapper.find('[data-testid="close-btn"]').trigger('click')
      expect(wrapper.emitted('close')).toBeTruthy()
    })
  })

  describe('user interactions', () => {
    it('should update internal state on input', async () => {
      const input = wrapper.find('input')
      await input.setValue('new value')
      
      expect(wrapper.vm.internalValue).toBe('new value')
    })
  })
})
```

### Composable Test Template

```typescript
// src/composables/__tests__/use-counter.spec.ts
import { describe, it, expect } from 'vitest'
import { useCounter } from '../use-counter'

describe('useCounter', () => {
  it('should initialize with default value', () => {
    const { count } = useCounter()
    expect(count.value).toBe(0)
  })

  it('should initialize with provided value', () => {
    const { count } = useCounter(10)
    expect(count.value).toBe(10)
  })

  it('should increment count', () => {
    const { count, increment } = useCounter()
    increment()
    expect(count.value).toBe(1)
  })

  it('should decrement count', () => {
    const { count, decrement } = useCounter(5)
    decrement()
    expect(count.value).toBe(4)
  })

  it('should reset to initial value', () => {
    const { count, increment, reset } = useCounter(5)
    increment()
    increment()
    reset()
    expect(count.value).toBe(5)
  })
})
```

### Pinia Store Test Template

```typescript
// src/stores/__tests__/user-store.spec.ts
import { setActivePinia, createPinia } from 'pinia'
import { describe, it, expect, beforeEach, vi } from 'vitest'
import { useUserStore } from '../user-store'

// Mock API
vi.mock('src/boot/axios', () => ({
  api: {
    get: vi.fn(),
    post: vi.fn(),
    put: vi.fn(),
    delete: vi.fn()
  }
}))

describe('useUserStore', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
    vi.clearAllMocks()
  })

  it('should have empty user initially', () => {
    const store = useUserStore()
    expect(store.user).toBeNull()
  })

  it('should set user on login', async () => {
    const store = useUserStore()
    const mockUser = { id: 1, name: 'John', email: 'john@test.com' }
    
    // Mock API response
    const { api } = await import('src/boot/axios')
    vi.mocked(api.post).mockResolvedValueOnce({ data: mockUser })
    
    await store.login('john@test.com', 'password')
    
    expect(store.user).toEqual(mockUser)
    expect(store.isAuthenticated).toBe(true)
  })

  it('should clear user on logout', () => {
    const store = useUserStore()
    store.user = { id: 1, name: 'John', email: 'john@test.com' }
    
    store.logout()
    
    expect(store.user).toBeNull()
    expect(store.isAuthenticated).toBe(false)
  })
})
```

### E2E Test Template (Playwright)

```typescript
// test/e2e/login.spec.ts
import { test, expect } from '@playwright/test'

test.describe('Login Flow', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/login')
  })

  test('should display login form', async ({ page }) => {
    await expect(page.getByRole('heading', { name: /login/i })).toBeVisible()
    await expect(page.getByLabel(/email/i)).toBeVisible()
    await expect(page.getByLabel(/password/i)).toBeVisible()
    await expect(page.getByRole('button', { name: /sign in/i })).toBeVisible()
  })

  test('should show validation errors for empty form', async ({ page }) => {
    await page.getByRole('button', { name: /sign in/i }).click()
    
    await expect(page.getByText(/email is required/i)).toBeVisible()
    await expect(page.getByText(/password is required/i)).toBeVisible()
  })

  test('should login successfully with valid credentials', async ({ page }) => {
    await page.getByLabel(/email/i).fill('test@example.com')
    await page.getByLabel(/password/i).fill('password123')
    await page.getByRole('button', { name: /sign in/i }).click()
    
    // Should redirect to dashboard
    await expect(page).toHaveURL('/dashboard')
    await expect(page.getByText(/welcome/i)).toBeVisible()
  })

  test('should show error for invalid credentials', async ({ page }) => {
    await page.getByLabel(/email/i).fill('wrong@example.com')
    await page.getByLabel(/password/i).fill('wrongpassword')
    await page.getByRole('button', { name: /sign in/i }).click()
    
    await expect(page.getByText(/invalid credentials/i)).toBeVisible()
    await expect(page).toHaveURL('/login')
  })
})
```

### Test Data Attributes

Always add `data-testid` attributes for test selectors:

```vue
<template>
  <q-card data-testid="user-card">
    <q-card-section>
      <div data-testid="user-name">{{ user.name }}</div>
    </q-card-section>
    <q-card-actions>
      <q-btn data-testid="edit-btn" @click="emit('edit')">Edit</q-btn>
      <q-btn data-testid="delete-btn" @click="emit('delete')">Delete</q-btn>
    </q-card-actions>
  </q-card>
</template>
```

---

## Pinia Store Pattern

```typescript
// src/stores/example-store.ts
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { api } from 'src/boot/axios'
import type { Example } from 'src/types'

export const useExampleStore = defineStore('example', () => {
  // ============ State ============
  const items = ref<Example[]>([])
  const currentItem = ref<Example | null>(null)
  const loading = ref(false)
  const error = ref<string | null>(null)

  // ============ Getters ============
  const itemCount = computed(() => items.value.length)
  const hasItems = computed(() => items.value.length > 0)
  const getById = computed(() => {
    return (id: number) => items.value.find(item => item.id === id)
  })

  // ============ Actions ============
  const fetchItems = async () => {
    loading.value = true
    error.value = null
    try {
      const response = await api.get<Example[]>('/examples')
      items.value = response.data
    } catch (e) {
      error.value = e instanceof Error ? e.message : 'Failed to fetch items'
      throw e
    } finally {
      loading.value = false
    }
  }

  const createItem = async (data: Omit<Example, 'id'>) => {
    loading.value = true
    try {
      const response = await api.post<Example>('/examples', data)
      items.value.push(response.data)
      return response.data
    } finally {
      loading.value = false
    }
  }

  const updateItem = async (id: number, data: Partial<Example>) => {
    loading.value = true
    try {
      const response = await api.put<Example>(`/examples/${id}`, data)
      const index = items.value.findIndex(item => item.id === id)
      if (index !== -1) {
        items.value[index] = response.data
      }
      return response.data
    } finally {
      loading.value = false
    }
  }

  const deleteItem = async (id: number) => {
    loading.value = true
    try {
      await api.delete(`/examples/${id}`)
      items.value = items.value.filter(item => item.id !== id)
    } finally {
      loading.value = false
    }
  }

  const $reset = () => {
    items.value = []
    currentItem.value = null
    loading.value = false
    error.value = null
  }

  return {
    // State
    items,
    currentItem,
    loading,
    error,
    // Getters
    itemCount,
    hasItems,
    getById,
    // Actions
    fetchItems,
    createItem,
    updateItem,
    deleteItem,
    $reset
  }
})
```

---

## Composable Pattern

```typescript
// src/composables/use-pagination.ts
import { ref, computed, watch } from 'vue'
import type { Ref } from 'vue'

interface UsePaginationOptions {
  initialPage?: number
  initialPerPage?: number
  total: Ref<number>
}

export function usePagination(options: UsePaginationOptions) {
  const { initialPage = 1, initialPerPage = 10, total } = options

  const currentPage = ref(initialPage)
  const perPage = ref(initialPerPage)

  const totalPages = computed(() => Math.ceil(total.value / perPage.value))
  const offset = computed(() => (currentPage.value - 1) * perPage.value)
  
  const hasNextPage = computed(() => currentPage.value < totalPages.value)
  const hasPrevPage = computed(() => currentPage.value > 1)

  const goToPage = (page: number) => {
    if (page >= 1 && page <= totalPages.value) {
      currentPage.value = page
    }
  }

  const nextPage = () => {
    if (hasNextPage.value) {
      currentPage.value++
    }
  }

  const prevPage = () => {
    if (hasPrevPage.value) {
      currentPage.value--
    }
  }

  const setPerPage = (value: number) => {
    perPage.value = value
    currentPage.value = 1 // Reset to first page
  }

  // Reset to page 1 when total changes significantly
  watch(total, (newTotal) => {
    if (offset.value >= newTotal) {
      currentPage.value = 1
    }
  })

  return {
    currentPage,
    perPage,
    totalPages,
    offset,
    hasNextPage,
    hasPrevPage,
    goToPage,
    nextPage,
    prevPage,
    setPerPage
  }
}
```

---

## API Integration

### Boot File Setup

```typescript
// src/boot/axios.ts
import { boot } from 'quasar/wrappers'
import axios, { AxiosInstance, AxiosError } from 'axios'
import { Notify } from 'quasar'

declare module '@vue/runtime-core' {
  interface ComponentCustomProperties {
    $axios: AxiosInstance
    $api: AxiosInstance
  }
}

const api = axios.create({
  baseURL: process.env.API_BASE_URL || '/api',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
})

// Request interceptor - add auth token
api.interceptors.request.use(
  config => {
    const token = localStorage.getItem('auth_token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  error => Promise.reject(error)
)

// Response interceptor - handle errors globally
api.interceptors.response.use(
  response => response,
  (error: AxiosError) => {
    const message = getErrorMessage(error)

    // Show notification for errors (except 401 which is handled by auth)
    if (error.response?.status !== 401) {
      Notify.create({
        type: 'negative',
        message,
        position: 'top'
      })
    }

    // Handle 401 - redirect to login
    if (error.response?.status === 401) {
      localStorage.removeItem('auth_token')
      window.location.href = '/login'
    }

    return Promise.reject(error)
  }
)

function getErrorMessage(error: AxiosError): string {
  if (error.response?.data && typeof error.response.data === 'object') {
    const data = error.response.data as Record<string, unknown>
    if (typeof data.message === 'string') return data.message
  }
  if (error.message) return error.message
  return 'An unexpected error occurred'
}

export default boot(({ app }) => {
  app.config.globalProperties.$axios = axios
  app.config.globalProperties.$api = api
})

export { api }
```

---

## Git Workflow

### Conventional Commits

Format: `type(scope): description`

**Types**:
| Type | Description |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Formatting, no code change |
| `refactor` | Code change that neither fixes nor adds |
| `perf` | Performance improvement |
| `test` | Adding or fixing tests |
| `chore` | Maintenance tasks |
| `ci` | CI/CD changes |
| `build` | Build system changes |

**Examples**:
```bash
feat(auth): add login with Google OAuth
fix(cart): correct total calculation with discounts
docs(readme): update installation instructions
test(user-store): add tests for logout action
refactor(components): extract shared form validation logic
```

### Branch Naming

```
feature/user-authentication
feature/shopping-cart
fix/login-redirect-loop
fix/cart-total-calculation
refactor/extract-form-composable
test/add-e2e-checkout-flow
docs/api-documentation
chore/upgrade-dependencies
```

---

## Quasar-Specific Patterns

### Platform Detection

```typescript
import { useQuasar } from 'quasar'

const $q = useQuasar()

// Platform checks
if ($q.platform.is.mobile) {
  /* mobile-specific logic */
}
if ($q.platform.is.desktop) {
  /* desktop-specific logic */
}
if ($q.platform.is.electron) {
  /* Electron-specific logic */
}
if ($q.platform.is.cordova) {
  /* Cordova-specific logic */
}
if ($q.platform.is.capacitor) {
  /* Capacitor-specific logic */
}

// Screen size (reactive)
if ($q.screen.lt.md) {
  /* smaller than medium */
}
if ($q.screen.gt.sm) {
  /* greater than small */
}
```

### Dialogs & Notifications

```typescript
import { useQuasar } from 'quasar'

const $q = useQuasar()

// Simple notification
$q.notify({
  message: 'Operation successful',
  type: 'positive', // 'positive' | 'negative' | 'warning' | 'info'
  position: 'top'
})

// Confirmation dialog
$q.dialog({
  title: 'Confirm',
  message: 'Are you sure you want to delete this item?',
  cancel: true,
  persistent: true
})
  .onOk(() => {
    // User confirmed
  })
  .onCancel(() => {
    // User cancelled
  })

// Loading indicator
$q.loading.show({ message: 'Loading...' })
// ... async operation
$q.loading.hide()
```

### Layout with QPage

```vue
<!-- src/layouts/MainLayout.vue -->
<template>
  <q-layout view="hHh lpR fFf">
    <q-header elevated>
      <q-toolbar>
        <q-btn flat dense round icon="menu" @click="toggleLeftDrawer" />
        <q-toolbar-title>App Title</q-toolbar-title>
      </q-toolbar>
    </q-header>

    <q-drawer v-model="leftDrawerOpen" show-if-above bordered>
      <q-list>
        <q-item v-ripple clickable to="/">
          <q-item-section avatar>
            <q-icon name="home" />
          </q-item-section>
          <q-item-section>Home</q-item-section>
        </q-item>
      </q-list>
    </q-drawer>

    <q-page-container>
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const leftDrawerOpen = ref(false)
const toggleLeftDrawer = () => {
  leftDrawerOpen.value = !leftDrawerOpen.value
}
</script>
```

```vue
<!-- src/pages/IndexPage.vue -->
<template>
  <!-- QPage MUST be inside QLayout (via QPageContainer) -->
  <q-page padding>
    <h1 class="text-h4">Welcome</h1>
    <!-- Page content -->
  </q-page>
</template>
```

---

## Common Warnings & Gotchas

### ⚠️ Testing Gotchas

1. **Always call `installQuasarPlugin()`** at the top of test files that use Quasar components
2. **QPage requires QLayout** - mock the layout or test the page content separately
3. **Quasar generates UIDs** - add `for` attribute for stable snapshots, or stub components
4. **Async component updates** - use `await nextTick()` after triggering events

### ⚠️ TypeScript Gotchas

1. **Don't use `any`** - define proper interfaces
2. **Import types separately** - `import type { X } from 'y'`
3. **Quasar component props** - check Quasar docs for correct prop types

### ⚠️ Quasar Gotchas

1. **QPage outside QLayout** - will throw runtime error
2. **v-model on Quasar inputs** - use correct format (some use `update:model-value`)
3. **QTable columns** - `field` can be string or function
4. **SSR hydration** - be careful with browser-only APIs in setup()

### ⚠️ Git Hooks Gotchas

1. **Husky not running** - ensure `npm run prepare` was run after install
2. **lint-staged skipping files** - check `.gitignore` and lint-staged config
3. **Commitlint failing** - use exact format: `type(scope): description`

---

## Environment Variables

```bash
# .env.development
API_BASE_URL=http://localhost:3000/api
DEBUG=true

# .env.production
API_BASE_URL=https://api.yourapp.com
DEBUG=false
```

Access in code:

```typescript
const apiUrl = process.env.API_BASE_URL
```

---

## MCP Server Integration

The following MCP servers are configured for autonomous frontend development:

### Installed Servers

| Server | Purpose | Status |
|--------|---------|--------|
| `context7` | Real-time documentation for Vue/Quasar/Pinia/Vitest | ✓ Active |
| `playwright` | Browser automation, screenshots, visual testing | ✓ Active |
| `chrome-devtools` | Console logs, network requests, DOM inspection | ✓ Active |
| `figma` | Design import, tokens, component specs | ✓ Active |
| `axe-accessibility` | WCAG compliance, accessibility audits | ✓ Active |

### Context7 (Documentation)

Fetch accurate, up-to-date documentation to avoid hallucinated APIs:

```
"use context7 to get QTable documentation for custom columns"
"use context7 for Pinia setup with Vue Router"
"use context7 for Vitest mocking best practices"
"use context7 to check Vue 3 Composition API patterns"
```

### Playwright MCP (Browser Automation)

Control a real browser for visual verification and testing:

```
"use playwright to navigate to http://localhost:9000"
"use playwright to take a screenshot of the current page"
"use playwright to click the login button and fill the form"
"use playwright to test the dashboard at mobile viewport (375x667)"
"use playwright to verify the component renders correctly"
```

**Iterative Design Workflow:**
1. Provide visual mock (screenshot, Figma export)
2. Implement component code
3. "use playwright to screenshot localhost:9000 and compare to the mock"
4. Iterate until pixel-perfect match

### Chrome DevTools MCP (Debugging)

Access browser internals for debugging:

```
"use chrome-devtools to check for console errors"
"use chrome-devtools to monitor network requests"
"use chrome-devtools to inspect the DOM structure"
"use chrome-devtools to capture a performance trace"
"use chrome-devtools to execute JavaScript in the browser context"
```

**Prerequisites:** Chrome must be running with remote debugging. Use the provided script:
```bash
# From the frontend directory
./claude_tools/start-chrome-debug.sh
```
This launches Chrome on port 9222 with a dedicated debug profile (keeps your regular Chrome unaffected).

### Figma MCP (Design Input)

Import designs directly from Figma:

```
"use figma to read the component specs from [Figma URL]"
"use figma to extract design tokens (colors, spacing)"
"use figma to get the layout structure of the selected frame"
"use figma to list components in the design system file"
```

**Setup:** Requires Figma authentication. Enable in Figma Desktop:
1. Open Figma Desktop
2. Toggle to Dev Mode (Shift+D)
3. Enable MCP server in inspect panel

### Axe Accessibility MCP (A11y Testing)

Automated WCAG compliance checking:

```
"use axe-accessibility to scan http://localhost:9000 for accessibility issues"
"use axe-accessibility to check the form for WCAG compliance"
"use axe-accessibility to generate an accessibility report"
"use axe-accessibility to verify color contrast ratios"
```

### Autonomous Development Workflow

With all MCP servers, Claude can work autonomously:

```
1. DESIGN → Read Figma designs, extract tokens
2. DOCS   → Fetch current Vue/Quasar docs via Context7
3. CODE   → Implement with TDD (tests first)
4. VIEW   → Open browser via Playwright, take screenshots
5. DEBUG  → Check console/network via Chrome DevTools
6. A11Y   → Run accessibility audit via Axe
7. ITERATE → Compare to design, fix issues, repeat
8. COMMIT → When all checks pass
```

---

## Project Setup

### Quick Start (Recommended)

Use the automated initialization script that configures everything:

```bash
cd /Users/simonmoon/Code/frontend
./claude_tools/init-project.sh <project-name>
cd <project-name>
quasar dev
```

The `init-project.sh` script automatically:
- Creates Quasar project with Vite, TypeScript, Pinia
- Installs and configures Vitest + Playwright
- Sets up ESLint, Prettier, Husky, Commitlint
- Creates Claude Code hooks (`.claude/settings.json`)
- Adds VS Code settings and extensions
- Creates test directory structure
- Copies the CLAUDE.md template

### Available Scripts

| Script | Purpose |
|--------|---------|
| `./claude_tools/init-project.sh <name>` | Create new project with full tooling |
| `./claude_tools/start-chrome-debug.sh` | Launch Chrome with debugging for DevTools MCP |

### Frontend Directory Contents

```
/Users/simonmoon/Code/frontend/
├── CLAUDE.md                      # This file - full development guide
├── claude_tools/                  # Scripts and templates for Claude Code
│   ├── CLAUDE-quasar-template.md      # Template copied to new projects
│   ├── claude-settings-template.json  # Hooks configuration reference
│   ├── vue-quasar-claude-code-workflow.md  # Detailed workflow documentation
│   ├── init-project.sh               # Project initialization script
│   └── start-chrome-debug.sh         # Chrome debugging launcher
└── flint/                         # FLINT chat interface project
```

### Manual Setup Checklist

If not using `init-project.sh`, ensure these are configured:

#### Initial Setup
- [ ] Create Quasar project: `npm init quasar`
- [ ] Select: Vite, TypeScript, Pinia, ESLint + Prettier
- [ ] Add Vitest: `quasar ext add @quasar/testing-unit-vitest`
- [ ] Install Playwright: `npm init playwright@latest`

#### Tooling Setup
- [ ] Install dev dependencies (see package.json section above)
- [ ] Configure ESLint (`.eslintrc.cjs`)
- [ ] Configure Prettier (`.prettierrc`, `.prettierignore`)
- [ ] Setup Husky: `npx husky init`
- [ ] Configure lint-staged (`lint-staged.config.cjs`)
- [ ] Configure commitlint (`commitlint.config.cjs`)
- [ ] Create git hooks (`.husky/pre-commit`, `.husky/commit-msg`, `.husky/pre-push`)

#### Configuration Files
- [ ] Update `tsconfig.json` with strict settings
- [ ] Create `vitest.config.mts`
- [ ] Create `playwright.config.ts`
- [ ] Create `test/vitest-setup.ts`
- [ ] Add VS Code settings (`.vscode/settings.json`, `.vscode/extensions.json`)
- [ ] Create `.editorconfig`
- [ ] Create `.claude/settings.json` with hooks (copy from `claude_tools/claude-settings-template.json`)

#### Project Files
- [ ] Copy `claude_tools/CLAUDE-quasar-template.md` to project as `CLAUDE.md`
- [ ] Update `CLAUDE.md` with project-specific details
- [ ] Create `src/types/index.ts` for shared types
- [ ] Setup `src/boot/axios.ts` for API integration

---

## Quick Reference

### Creating New Feature Checklist

- [ ] Write failing unit tests for component/composable
- [ ] Run tests - confirm RED
- [ ] Implement minimal code to pass
- [ ] Run tests - confirm GREEN
- [ ] Refactor if needed
- [ ] Add E2E test for user flow (if applicable)
- [ ] Run full test suite
- [ ] Commit with conventional commit message

### Code Review Checklist

- [ ] Tests written and passing
- [ ] No `any` types
- [ ] Proper TypeScript interfaces defined
- [ ] Using Quasar components (not raw HTML)
- [ ] Using Quasar utility classes (not custom CSS for common patterns)
- [ ] `data-testid` attributes on interactive elements
- [ ] No console.log statements
- [ ] Props and emits properly typed
- [ ] Error handling in place
- [ ] Conventional commit message format
