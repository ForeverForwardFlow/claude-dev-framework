#!/bin/bash
#
# Backend Monorepo Initialization Script
# Creates a new npm workspaces + Turborepo monorepo with full tooling
#
# Usage: ./init-monorepo.sh <project-name>
#

set -e

PROJECT_NAME=$1
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -z "$PROJECT_NAME" ]; then
  echo "Usage: ./init-monorepo.sh <project-name>"
  exit 1
fi

echo "🚀 Creating new monorepo: $PROJECT_NAME"

# Check if directory already exists
if [ -d "$PROJECT_NAME" ]; then
  echo "❌ Directory $PROJECT_NAME already exists"
  exit 1
fi

# Create project directory
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

echo "📦 Initializing monorepo..."

# Initialize root package.json
cat > package.json << PACKAGEJSON
{
  "name": "$PROJECT_NAME",
  "version": "1.0.0",
  "private": true,
  "type": "module",
  "packageManager": "npm@10.8.1",
  "workspaces": [
    "packages/*",
    "shared"
  ],
  "scripts": {
    "build": "turbo run build",
    "dev": "turbo run dev",
    "test": "turbo run test",
    "test:coverage": "turbo run test:coverage",
    "typecheck": "turbo run typecheck",
    "lint": "eslint .",
    "lint:fix": "eslint . --fix",
    "format": "prettier --write .",
    "format:check": "prettier --check .",
    "prepare": "husky"
  },
  "engines": {
    "node": ">=20.0.0"
  }
}
PACKAGEJSON

echo "📦 Installing root dependencies..."

# Install root dev dependencies
npm install -D \
  turbo \
  typescript \
  eslint \
  @eslint/js \
  typescript-eslint \
  eslint-config-prettier \
  globals \
  prettier \
  husky \
  lint-staged \
  @commitlint/cli \
  @commitlint/config-conventional

echo "📝 Creating configuration files..."

# Create Turborepo config
cat > turbo.json << 'TURBO'
{
  "$schema": "https://turbo.build/schema.json",
  "tasks": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    },
    "test": {
      "dependsOn": ["build"],
      "outputs": ["coverage/**"]
    },
    "test:coverage": {
      "dependsOn": ["build"],
      "outputs": ["coverage/**"]
    },
    "typecheck": {
      "dependsOn": ["^build"]
    },
    "lint": {},
    "format": {}
  }
}
TURBO

# Create ESLint config
cat > eslint.config.js << 'ESLINT'
import eslint from '@eslint/js';
import tseslint from 'typescript-eslint';
import eslintConfigPrettier from 'eslint-config-prettier';
import globals from 'globals';

export default tseslint.config(
  // Global ignores
  {
    ignores: [
      '**/dist/**',
      '**/node_modules/**',
      '**/coverage/**',
      '**/*.js',
      '**/*.mjs',
      '!eslint.config.js',
    ],
  },

  // Base ESLint recommended rules
  eslint.configs.recommended,

  // TypeScript recommended rules
  ...tseslint.configs.recommended,

  // Prettier compatibility
  eslintConfigPrettier,

  // Custom configuration
  {
    files: ['**/*.ts'],
    languageOptions: {
      ecmaVersion: 2024,
      sourceType: 'module',
      globals: {
        ...globals.node,
        ...globals.es2024,
      },
      parserOptions: {
        project: ['./packages/*/tsconfig.json', './shared/tsconfig.json'],
        tsconfigRootDir: import.meta.dirname,
      },
    },
    rules: {
      '@typescript-eslint/no-unused-vars': [
        'error',
        {
          argsIgnorePattern: '^_',
          varsIgnorePattern: '^_',
          caughtErrorsIgnorePattern: '^_',
        },
      ],
      '@typescript-eslint/no-explicit-any': 'warn',
      '@typescript-eslint/explicit-function-return-type': 'off',
      'no-console': 'off',
      'prefer-const': 'error',
      'no-var': 'error',
      eqeqeq: ['error', 'always', { null: 'ignore' }],
    },
  },

  // Test file specific rules
  {
    files: ['**/*.test.ts', '**/*.spec.ts'],
    languageOptions: {
      parserOptions: {
        project: null,
      },
    },
    rules: {
      '@typescript-eslint/no-explicit-any': 'off',
      '@typescript-eslint/no-non-null-assertion': 'off',
    },
  }
);
ESLINT

# Create Prettier config
cat > .prettierrc << 'PRETTIER'
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 100,
  "bracketSpacing": true,
  "arrowParens": "always",
  "endOfLine": "lf"
}
PRETTIER

cat > .prettierignore << 'PRETTIERIGNORE'
dist
node_modules
coverage
.turbo
*.min.js
PRETTIERIGNORE

# Create commitlint config
cat > commitlint.config.js << 'COMMITLINT'
export default {
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
};
COMMITLINT

# Create .gitignore
cat > .gitignore << 'GITIGNORE'
# Dependencies
node_modules/

# Build output
dist/
.turbo/

# Test coverage
coverage/

# Environment and secrets
.env
.dev.vars
*.json.bak

# Credentials (never commit)
**/credentials.json
**/token.json

# OS files
.DS_Store
Thumbs.db

# IDE
.idea/
*.swp
*.swo

# Logs
*.log
npm-debug.log*
GITIGNORE

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

# Create shared package
echo "📦 Creating shared package..."
mkdir -p shared/src

cat > shared/package.json << 'SHAREDPKG'
{
  "name": "@PROJECT_NAME/shared",
  "version": "1.0.0",
  "type": "module",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "scripts": {
    "build": "tsc",
    "dev": "tsc --watch",
    "typecheck": "tsc --noEmit",
    "test": "vitest run",
    "test:watch": "vitest",
    "test:coverage": "vitest run --coverage"
  }
}
SHAREDPKG

# Replace placeholder
sed -i '' "s/PROJECT_NAME/$PROJECT_NAME/g" shared/package.json 2>/dev/null || \
sed -i "s/PROJECT_NAME/$PROJECT_NAME/g" shared/package.json

cat > shared/tsconfig.json << 'SHAREDTS'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "lib": ["ES2022"],
    "types": ["node"],
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "declaration": true,
    "resolveJsonModule": true,
    "isolatedModules": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "**/*.test.ts"]
}
SHAREDTS

cat > shared/vitest.config.ts << 'SHAREDVITEST'
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    include: ['src/**/*.test.ts'],
  },
});
SHAREDVITEST

cat > shared/src/index.ts << 'SHAREDINDEX'
// Re-export shared utilities
export * from './errors.js';
export * from './validation.js';
SHAREDINDEX

cat > shared/src/errors.ts << 'SHAREDERRORS'
/**
 * Custom error class with field tracking for validation errors
 */
export class ValidationError extends Error {
  constructor(
    message: string,
    public field?: string
  ) {
    super(message);
    this.name = 'ValidationError';
  }
}

/**
 * Sanitize error message by removing sensitive data
 */
export function sanitizeError(error: unknown): Error {
  const message = error instanceof Error ? error.message : String(error);
  const sanitized = message
    .replace(/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/g, '[email]')
    .replace(/Bearer\s+[A-Za-z0-9-._~+/]+=*/g, 'Bearer [token]')
    .replace(/access_token=[^&\s]+/g, 'access_token=[redacted]')
    .replace(/refresh_token=[^&\s]+/g, 'refresh_token=[redacted]')
    .replace(/api[_-]?key[=:][^&\s]+/gi, 'api_key=[redacted]');

  if (error instanceof Error) {
    error.message = sanitized;
    return error;
  }
  return new Error(sanitized);
}

/**
 * Sanitize error message (returns string)
 */
export function sanitizeErrorMessage(error: unknown): string {
  return sanitizeError(error).message;
}
SHAREDERRORS

cat > shared/src/validation.ts << 'SHAREDVALIDATION'
import { z } from 'zod';

/**
 * Create a standardized MCP error response
 */
export function createMcpErrorResponse(message: string) {
  return {
    content: [{ type: 'text' as const, text: message }],
    isError: true,
  };
}

/**
 * Example base schema - extend in packages
 */
export const BaseInputSchema = z.object({
  // Common fields can go here
});
SHAREDVALIDATION

cat > shared/src/errors.test.ts << 'SHAREDERRORSTEST'
import { describe, it, expect } from 'vitest';
import { ValidationError, sanitizeError, sanitizeErrorMessage } from './errors.js';

describe('ValidationError', () => {
  it('should create error with message', () => {
    const error = new ValidationError('Invalid input');
    expect(error.message).toBe('Invalid input');
    expect(error.name).toBe('ValidationError');
  });

  it('should include field name', () => {
    const error = new ValidationError('Required', 'email');
    expect(error.field).toBe('email');
  });
});

describe('sanitizeError', () => {
  it('should redact email addresses', () => {
    const result = sanitizeError(new Error('Error for user@example.com'));
    expect(result.message).toBe('Error for [email]');
  });

  it('should redact bearer tokens', () => {
    const result = sanitizeError('Bearer abc123xyz');
    expect(result.message).toBe('Bearer [token]');
  });
});

describe('sanitizeErrorMessage', () => {
  it('should return sanitized string', () => {
    const result = sanitizeErrorMessage('api_key=secret123');
    expect(result).toBe('api_key=[redacted]');
  });
});
SHAREDERRORSTEST

# Install shared package dependencies
cd shared
npm install zod
npm install -D typescript vitest @vitest/coverage-v8 @types/node
cd ..

# Create packages directory
mkdir -p packages

# Create example package
echo "📦 Creating example package..."
mkdir -p packages/example/src

cat > packages/example/package.json << 'EXAMPLEPKG'
{
  "name": "@PROJECT_NAME/example",
  "version": "1.0.0",
  "type": "module",
  "main": "dist/index.js",
  "scripts": {
    "build": "tsc",
    "dev": "wrangler dev",
    "deploy": "wrangler deploy",
    "typecheck": "tsc --noEmit",
    "test": "vitest run",
    "test:watch": "vitest",
    "test:coverage": "vitest run --coverage"
  }
}
EXAMPLEPKG

sed -i '' "s/PROJECT_NAME/$PROJECT_NAME/g" packages/example/package.json 2>/dev/null || \
sed -i "s/PROJECT_NAME/$PROJECT_NAME/g" packages/example/package.json

cat > packages/example/tsconfig.json << 'EXAMPLETS'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "lib": ["ES2022"],
    "types": ["@cloudflare/workers-types", "node"],
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "declaration": true,
    "resolveJsonModule": true,
    "isolatedModules": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "**/*.test.ts"]
}
EXAMPLETS

cat > packages/example/vitest.config.ts << 'EXAMPLEVITEST'
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    include: ['src/**/*.test.ts'],
  },
});
EXAMPLEVITEST

cat > packages/example/wrangler.toml << 'EXAMPLEWRANGLER'
#:schema node_modules/wrangler/config-schema.json
name = "example"
main = "dist/index.js"
compatibility_date = "2024-01-01"
EXAMPLEWRANGLER

cat > packages/example/src/index.ts << 'EXAMPLEINDEX'
export interface Env {
  // Add bindings here
}

export default {
  async fetch(request: Request, _env: Env): Promise<Response> {
    const url = new URL(request.url);

    if (url.pathname === '/health') {
      return Response.json({ status: 'ok' });
    }

    return Response.json({ message: 'Hello from example package!' });
  },
};
EXAMPLEINDEX

cat > packages/example/src/index.test.ts << 'EXAMPLETEST'
import { describe, it, expect } from 'vitest';

describe('example', () => {
  it('should pass', () => {
    expect(true).toBe(true);
  });
});
EXAMPLETEST

# Install example package dependencies
cd packages/example
npm install zod
npm install -D typescript vitest @vitest/coverage-v8 @types/node wrangler @cloudflare/workers-types
cd ../..

echo "🔨 Setting up Husky..."
git init
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
npm run test

if [ $? -ne 0 ]; then
  echo "❌ Tests failed. Push aborted."
  exit 1
fi

echo "✅ All tests passed. Pushing..."
PREPUSH
chmod +x .husky/pre-push

# Add lint-staged config to package.json
npm pkg set lint-staged='{"*.ts": ["eslint --fix", "prettier --write"], "*.{json,md,yml,yaml}": ["prettier --write"]}'

# Create VS Code settings
mkdir -p .vscode
cat > .vscode/settings.json << 'VSCODE'
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit"
  },
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "typescript.tsdk": "node_modules/typescript/lib",
  "eslint.validate": ["javascript", "typescript"]
}
VSCODE

# Create Claude Code settings
mkdir -p .claude
cat > .claude/settings.json << 'CLAUDESETTINGS'
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit:*.ts|Write:*.ts",
        "hooks": [
          {
            "type": "command",
            "command": "npx eslint --fix --quiet $CLAUDE_FILE_PATHS 2>/dev/null || true"
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
            "command": "echo '🔍 Quality checks...' && npm run typecheck 2>&1 | tail -5 && npm run lint --quiet 2>&1 | tail -5 && npm run test 2>&1 | tail -10 && echo '✅ Done'"
          }
        ]
      }
    ]
  }
}
CLAUDESETTINGS

# Create CLAUDE.md
cat > CLAUDE.md << 'CLAUDEMD'
# PROJECT_NAME_PLACEHOLDER

## Overview

<!-- UPDATE: Describe your project here -->
Monorepo containing multiple TypeScript packages.

## Tech Stack

- **Build**: Turborepo for task orchestration
- **Workspaces**: npm workspaces
- **Language**: TypeScript (strict mode)
- **Testing**: Vitest
- **Linting**: ESLint 9 + Prettier

## Commands

```bash
# Build all packages
npm run build

# Run all tests
npm run test

# Type-check all packages
npm run typecheck

# Lint all packages
npm run lint
npm run lint:fix

# Format all packages
npm run format
```

## Project Structure

```
packages/
├── example/           # Example package (rename/replace)
│   ├── src/
│   ├── package.json
│   └── tsconfig.json
└── [your-packages]/

shared/                # Shared utilities
├── src/
│   ├── errors.ts     # Error handling
│   └── validation.ts # Common schemas
└── package.json
```

## Adding a New Package

1. Create directory: `mkdir -p packages/my-package/src`
2. Copy `packages/example/package.json` and update name
3. Copy `packages/example/tsconfig.json`
4. Run `npm install` from root

## Conventions

- Use `@PROJECT_NAME_PLACEHOLDER/` prefix for package names
- Shared code goes in `shared/`
- Each package has its own `tsconfig.json`
- Tests live alongside source files (`*.test.ts`)

## Claude Code Instructions

1. **Read before editing** - Always read files before changes
2. **Write tests** - New features require tests
3. **Run checks before commits** - typecheck, lint, test
4. **Use conventional commits** - `feat:`, `fix:`, etc.
CLAUDEMD

sed -i '' "s/PROJECT_NAME_PLACEHOLDER/$PROJECT_NAME/g" CLAUDE.md 2>/dev/null || \
sed -i "s/PROJECT_NAME_PLACEHOLDER/$PROJECT_NAME/g" CLAUDE.md

# Install all dependencies
echo "📦 Installing all workspace dependencies..."
npm install

# Build everything
echo "🔨 Building all packages..."
npm run build

# Run tests
echo "🧪 Running tests..."
npm run test

echo ""
echo "✅ Monorepo $PROJECT_NAME created successfully!"
echo ""
echo "📋 Next steps:"
echo "   cd $PROJECT_NAME"
echo "   npm run build        # Build all packages"
echo "   npm run test         # Run all tests"
echo "   npm run dev          # Start dev mode"
echo ""
echo "📦 Packages:"
echo "   - shared/            # Shared utilities"
echo "   - packages/example/  # Example package (rename or delete)"
echo ""
echo "💡 To add a new package:"
echo "   mkdir -p packages/my-package/src"
echo "   # Copy and modify packages/example/package.json"
echo "   npm install"
echo ""
echo "🚀 Happy coding!"
