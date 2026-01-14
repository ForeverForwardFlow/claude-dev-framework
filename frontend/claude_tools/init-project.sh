#!/bin/bash
#
# Frontend Project Initialization Script
# Creates a new Quasar project with full tooling pre-configured
#
# Usage: ./init-project.sh <project-name>
#

set -e

PROJECT_NAME=$1
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -z "$PROJECT_NAME" ]; then
  echo "Usage: ./init-project.sh <project-name>"
  exit 1
fi

echo "🚀 Creating new Quasar project: $PROJECT_NAME"

# Check if directory already exists
if [ -d "$PROJECT_NAME" ]; then
  echo "❌ Directory $PROJECT_NAME already exists"
  exit 1
fi

# Create Quasar project with preset options
echo "📦 Initializing Quasar project..."
npm init quasar <<EOF
$PROJECT_NAME
quasar-v2
app-vite
typescript
pinia
sass-with-variables
eslint-prettier
vue-router
EOF

cd "$PROJECT_NAME"

echo "📦 Installing additional dependencies..."

# Install dev dependencies for testing and tooling
npm install -D \
  @commitlint/cli \
  @commitlint/config-conventional \
  @playwright/test \
  @quasar/quasar-app-extension-testing-unit-vitest \
  @vitest/coverage-v8 \
  @vitest/ui \
  husky \
  lint-staged \
  jsdom

echo "🔧 Adding Vitest testing extension..."
quasar ext add @quasar/testing-unit-vitest

echo "🎭 Installing Playwright browsers..."
npx playwright install chromium

echo "📝 Creating configuration files..."

# Create commitlint config
cat > commitlint.config.cjs << 'COMMITLINT'
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [
      2,
      'always',
      ['feat', 'fix', 'docs', 'style', 'refactor', 'perf', 'test', 'chore', 'ci', 'build', 'revert']
    ],
    'subject-case': [2, 'always', 'lower-case'],
    'subject-max-length': [2, 'always', 72],
    'header-max-length': [2, 'always', 100]
  }
}
COMMITLINT

# Create lint-staged config
cat > lint-staged.config.cjs << 'LINTSTAGED'
module.exports = {
  '*.vue': ['eslint --fix', 'prettier --write'],
  '*.{ts,tsx}': ['eslint --fix', 'prettier --write'],
  '*.{js,jsx,cjs,mjs}': ['eslint --fix', 'prettier --write'],
  '*.{css,scss,sass}': ['prettier --write'],
  '*.{json,md,yaml,yml}': ['prettier --write']
}
LINTSTAGED

# Create Playwright config
cat > playwright.config.ts << 'PLAYWRIGHT'
import { defineConfig, devices } from '@playwright/test'

export default defineConfig({
  testDir: './test/e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [['html', { outputFolder: 'playwright-report' }], ['list']],
  use: {
    baseURL: 'http://localhost:9000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure'
  },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
    { name: 'Mobile Chrome', use: { ...devices['Pixel 5'] } }
  ],
  webServer: {
    command: 'quasar dev',
    url: 'http://localhost:9000',
    reuseExistingServer: !process.env.CI,
    timeout: 120 * 1000
  }
})
PLAYWRIGHT

# Create .editorconfig
cat > .editorconfig << 'EDITORCONFIG'
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
EDITORCONFIG

# Create test directories
mkdir -p test/e2e
mkdir -p src/components/__tests__
mkdir -p src/composables/__tests__
mkdir -p src/stores/__tests__

# Create Vitest setup file
cat > test/vitest-setup.ts << 'VITESTSETUP'
import { config } from '@vue/test-utils'
import { Quasar } from 'quasar'
import { vi } from 'vitest'

config.global.plugins.push([Quasar, {}])

class MockIntersectionObserver {
  observe = vi.fn()
  disconnect = vi.fn()
  unobserve = vi.fn()
}

Object.defineProperty(window, 'IntersectionObserver', {
  writable: true,
  value: MockIntersectionObserver
})

class MockResizeObserver {
  observe = vi.fn()
  disconnect = vi.fn()
  unobserve = vi.fn()
}

Object.defineProperty(window, 'ResizeObserver', {
  writable: true,
  value: MockResizeObserver
})

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

window.scrollTo = vi.fn()
VITESTSETUP

# Create example E2E test
cat > test/e2e/home.spec.ts << 'E2ETEST'
import { test, expect } from '@playwright/test'

test.describe('Home Page', () => {
  test('should display the home page', async ({ page }) => {
    await page.goto('/')
    await expect(page).toHaveTitle(/Quasar/)
  })
})
E2ETEST

# Create src/types/index.ts
mkdir -p src/types
cat > src/types/index.ts << 'TYPES'
// Shared TypeScript type definitions

export interface ApiResponse<T> {
  data: T
  message: string
  success: boolean
}

export interface User {
  id: number
  email: string
  name: string
  avatar?: string
}
TYPES

echo "🔨 Setting up Husky..."
npx husky init

# Create pre-commit hook
cat > .husky/pre-commit << 'PRECOMMIT'
npx lint-staged
PRECOMMIT
chmod +x .husky/pre-commit

# Create commit-msg hook
cat > .husky/commit-msg << 'COMMITMSG'
npx --no -- commitlint --edit "$1"
COMMITMSG
chmod +x .husky/commit-msg

# Create pre-push hook
cat > .husky/pre-push << 'PREPUSH'
echo "🧪 Running tests before push..."
npm run test:unit:run

if [ $? -ne 0 ]; then
  echo "❌ Tests failed. Push aborted."
  exit 1
fi

echo "✅ All tests passed. Pushing..."
PREPUSH
chmod +x .husky/pre-push

# Update package.json scripts
npm pkg set scripts.test:unit="vitest"
npm pkg set scripts.test:unit:run="vitest run"
npm pkg set scripts.test:unit:ui="vitest --ui"
npm pkg set scripts.test:unit:coverage="vitest run --coverage"
npm pkg set scripts.test:e2e="playwright test"
npm pkg set scripts.test:e2e:ui="playwright test --ui"
npm pkg set scripts.type-check="vue-tsc --noEmit"
npm pkg set scripts.quality="npm run type-check && npm run lint && npm run test:unit:run"

# Create VS Code settings
mkdir -p .vscode
cat > .vscode/settings.json << 'VSCODE'
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit"
  },
  "[vue]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "typescript.tsdk": "node_modules/typescript/lib",
  "eslint.validate": ["javascript", "typescript", "vue"]
}
VSCODE

cat > .vscode/extensions.json << 'EXTENSIONS'
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
EXTENSIONS

# Create .claude directory with settings
mkdir -p .claude
cat > .claude/settings.json << 'CLAUDESETTINGS'
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit:*.vue|Edit:*.ts|Edit:*.tsx|Write:*.vue|Write:*.ts|Write:*.tsx",
        "hooks": [
          {
            "type": "command",
            "command": "npx eslint --fix --quiet $CLAUDE_FILE_PATHS 2>/dev/null || true"
          }
        ]
      },
      {
        "matcher": "Edit:*.spec.ts|Edit:*.test.ts|Write:*.spec.ts|Write:*.test.ts",
        "hooks": [
          {
            "type": "command",
            "command": "npm run test:unit -- --run --reporter=dot --passWithNoTests 2>&1 | head -20"
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
            "command": "echo '🔍 Quality checks...' && npm run type-check --silent 2>&1 | tail -5 && npm run lint --silent -- --quiet 2>&1 | tail -5 && npm run test:unit -- --run --passWithNoTests --reporter=dot 2>&1 | tail -10 && echo '✅ Done'"
          }
        ]
      }
    ]
  }
}
CLAUDESETTINGS

# Copy CLAUDE.md template
cp "$SCRIPT_DIR/CLAUDE-quasar-template.md" ./CLAUDE.md

echo ""
echo "✅ Project $PROJECT_NAME created successfully!"
echo ""
echo "📋 Next steps:"
echo "   cd $PROJECT_NAME"
echo "   quasar dev           # Start development server"
echo "   npm run test:unit    # Run unit tests"
echo "   npm run test:e2e     # Run E2E tests"
echo ""
echo "🔧 MCP servers available:"
echo "   - context7          (documentation)"
echo "   - playwright        (browser automation)"
echo "   - chrome-devtools   (debugging)"
echo "   - figma             (design import)"
echo "   - axe-accessibility (a11y testing)"
echo ""
echo "🚀 Happy coding!"
