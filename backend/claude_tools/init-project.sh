#!/bin/bash
#
# Backend Project Initialization Script
# Creates a new Cloudflare Workers project with full tooling pre-configured
#
# Usage: ./init-project.sh <project-name> [--mcp]
#
# Options:
#   --mcp    Include MCP server boilerplate (Model Context Protocol)
#

set -e

PROJECT_NAME=$1
INCLUDE_MCP=false
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Parse arguments
for arg in "$@"; do
  case $arg in
    --mcp)
      INCLUDE_MCP=true
      shift
      ;;
  esac
done

if [ -z "$PROJECT_NAME" ]; then
  echo "Usage: ./init-project.sh <project-name> [--mcp]"
  echo ""
  echo "Options:"
  echo "  --mcp    Include MCP server boilerplate"
  exit 1
fi

echo "🚀 Creating new Cloudflare Workers project: $PROJECT_NAME"

# Check if directory already exists
if [ -d "$PROJECT_NAME" ]; then
  echo "❌ Directory $PROJECT_NAME already exists"
  exit 1
fi

# Create project directory
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

echo "📦 Initializing project..."

# Initialize package.json
cat > package.json << PACKAGEJSON
{
  "name": "$PROJECT_NAME",
  "version": "1.0.0",
  "private": true,
  "type": "module",
  "main": "dist/index.js",
  "scripts": {
    "build": "tsc",
    "dev": "wrangler dev",
    "deploy": "wrangler deploy",
    "start": "node dist/index.js",
    "typecheck": "tsc --noEmit",
    "test": "vitest run",
    "test:watch": "vitest",
    "test:ui": "vitest --ui",
    "test:coverage": "vitest run --coverage",
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

echo "📦 Installing dependencies..."

# Install dependencies
npm install zod

# Install dev dependencies
npm install -D \
  typescript \
  @types/node \
  wrangler \
  @cloudflare/workers-types \
  vitest \
  @vitest/coverage-v8 \
  @vitest/ui \
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

if [ "$INCLUDE_MCP" = true ]; then
  echo "📦 Installing MCP dependencies..."
  npm install @modelcontextprotocol/sdk
fi

echo "📝 Creating configuration files..."

# Create TypeScript config
cat > tsconfig.json << 'TSCONFIG'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "lib": ["ES2022"],
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "declaration": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedIndexedAccess": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
TSCONFIG

# Create Vitest config
cat > vitest.config.ts << 'VITEST'
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    include: ['src/**/*.test.ts'],
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      exclude: [
        'node_modules/**',
        'dist/**',
        '**/*.test.ts',
        '**/*.d.ts',
        'vitest.config.ts',
        'eslint.config.js',
      ],
      thresholds: {
        statements: 70,
        branches: 60,
        functions: 70,
        lines: 70,
      },
    },
  },
});
VITEST

# Create ESLint config (ESLint 9 flat config)
cat > eslint.config.js << 'ESLINT'
import eslint from '@eslint/js';
import tseslint from 'typescript-eslint';
import eslintConfigPrettier from 'eslint-config-prettier';
import globals from 'globals';

export default tseslint.config(
  // Global ignores
  {
    ignores: ['**/dist/**', '**/node_modules/**', '**/coverage/**'],
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
        project: './tsconfig.json',
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

# Create Prettier ignore
cat > .prettierignore << 'PRETTIERIGNORE'
dist
node_modules
coverage
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

# Create Wrangler config
cat > wrangler.toml << 'WRANGLER'
#:schema node_modules/wrangler/config-schema.json
name = "PROJECT_NAME_PLACEHOLDER"
main = "dist/index.js"
compatibility_date = "2024-01-01"

# Uncomment for Durable Objects
# [[durable_objects.bindings]]
# name = "MY_DURABLE_OBJECT"
# class_name = "MyDurableObject"

# [[migrations]]
# tag = "v1"
# new_classes = ["MyDurableObject"]
WRANGLER

# Replace placeholder with actual project name
sed -i '' "s/PROJECT_NAME_PLACEHOLDER/$PROJECT_NAME/g" wrangler.toml 2>/dev/null || \
sed -i "s/PROJECT_NAME_PLACEHOLDER/$PROJECT_NAME/g" wrangler.toml

# Create .gitignore
cat > .gitignore << 'GITIGNORE'
# Dependencies
node_modules/

# Build output
dist/
.wrangler/

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

# Create source directory structure
mkdir -p src/tools
mkdir -p src/utils

# Create types file
cat > src/types.ts << 'TYPES'
// Shared TypeScript type definitions

export interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
}

export interface ToolResult {
  success: boolean;
  content: Array<{ type: 'text'; text: string }>;
  isError?: boolean;
}
TYPES

# Create validation utilities
cat > src/validation.ts << 'VALIDATION'
import { z } from 'zod';

/**
 * Sanitize error message by removing sensitive data
 */
export function sanitizeError(error: unknown): string {
  const message = error instanceof Error ? error.message : String(error);
  return message
    .replace(/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/g, '[email]')
    .replace(/Bearer\s+[A-Za-z0-9-._~+/]+=*/g, 'Bearer [token]')
    .replace(/access_token=[^&\s]+/g, 'access_token=[redacted]')
    .replace(/refresh_token=[^&\s]+/g, 'refresh_token=[redacted]')
    .replace(/api[_-]?key[=:][^&\s]+/gi, 'api_key=[redacted]');
}

/**
 * Example schema - replace with your own
 */
export const ExampleInputSchema = z.object({
  name: z.string().min(1, 'Name is required'),
  value: z.number().positive('Value must be positive'),
});

export type ExampleInput = z.infer<typeof ExampleInputSchema>;
VALIDATION

# Create main entry point based on project type
if [ "$INCLUDE_MCP" = true ]; then
  cat > src/index.ts << 'MCPINDEX'
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';
import { sanitizeError } from './validation.js';

const server = new Server(
  {
    name: 'PROJECT_NAME_PLACEHOLDER',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// List available tools
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: 'example_tool',
        description: 'An example tool - replace with your implementation',
        inputSchema: {
          type: 'object',
          properties: {
            name: { type: 'string', description: 'Name parameter' },
            value: { type: 'number', description: 'Value parameter' },
          },
          required: ['name', 'value'],
        },
      },
    ],
  };
});

// Handle tool calls
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  try {
    switch (name) {
      case 'example_tool':
        return {
          content: [{ type: 'text', text: `Example result for: ${JSON.stringify(args)}` }],
        };

      default:
        return {
          content: [{ type: 'text', text: `Unknown tool: ${name}` }],
          isError: true,
        };
    }
  } catch (error) {
    return {
      content: [{ type: 'text', text: sanitizeError(error) }],
      isError: true,
    };
  }
});

// Start the server
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error('MCP server running on stdio');
}

main().catch(console.error);
MCPINDEX
  # Replace placeholder
  sed -i '' "s/PROJECT_NAME_PLACEHOLDER/$PROJECT_NAME/g" src/index.ts 2>/dev/null || \
  sed -i "s/PROJECT_NAME_PLACEHOLDER/$PROJECT_NAME/g" src/index.ts
else
  cat > src/index.ts << 'WORKERINDEX'
export interface Env {
  // Add your bindings here
  // MY_KV: KVNamespace;
  // MY_DURABLE_OBJECT: DurableObjectNamespace;
}

export default {
  async fetch(request: Request, env: Env, _ctx: ExecutionContext): Promise<Response> {
    const url = new URL(request.url);

    // Health check endpoint
    if (url.pathname === '/health') {
      return Response.json({ status: 'ok', timestamp: new Date().toISOString() });
    }

    // API routes
    if (url.pathname.startsWith('/api/')) {
      return handleApiRequest(request, env);
    }

    return new Response('Not Found', { status: 404 });
  },
};

async function handleApiRequest(request: Request, _env: Env): Promise<Response> {
  const url = new URL(request.url);
  const path = url.pathname.replace('/api', '');

  // Add your API routes here
  switch (path) {
    case '/example':
      return Response.json({ message: 'Hello from the API!' });

    default:
      return Response.json({ error: 'Not found' }, { status: 404 });
  }
}
WORKERINDEX
fi

# Create example test
cat > src/validation.test.ts << 'VALIDATIONTEST'
import { describe, it, expect } from 'vitest';
import { sanitizeError, ExampleInputSchema } from './validation';

describe('sanitizeError', () => {
  it('should redact email addresses', () => {
    const result = sanitizeError('Error for user@example.com');
    expect(result).toBe('Error for [email]');
    expect(result).not.toContain('user@example.com');
  });

  it('should redact bearer tokens', () => {
    const result = sanitizeError('Auth failed: Bearer abc123xyz');
    expect(result).toBe('Auth failed: Bearer [token]');
  });

  it('should redact API keys', () => {
    const result = sanitizeError('api_key=secret123');
    expect(result).toBe('api_key=[redacted]');
  });

  it('should handle Error objects', () => {
    const error = new Error('test@test.com failed');
    const result = sanitizeError(error);
    expect(result).toBe('[email] failed');
  });
});

describe('ExampleInputSchema', () => {
  it('should validate correct input', () => {
    const result = ExampleInputSchema.safeParse({ name: 'test', value: 42 });
    expect(result.success).toBe(true);
  });

  it('should reject empty name', () => {
    const result = ExampleInputSchema.safeParse({ name: '', value: 42 });
    expect(result.success).toBe(false);
  });

  it('should reject negative value', () => {
    const result = ExampleInputSchema.safeParse({ name: 'test', value: -1 });
    expect(result.success).toBe(false);
  });
});
VALIDATIONTEST

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
npm run typecheck && npm run test

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

cat > .vscode/extensions.json << 'EXTENSIONS'
{
  "recommendations": [
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode",
    "EditorConfig.EditorConfig",
    "vitest.explorer"
  ]
}
EXTENSIONS

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
      },
      {
        "matcher": "Edit:*.test.ts|Write:*.test.ts",
        "hooks": [
          {
            "type": "command",
            "command": "npm run test -- --run --reporter=dot --passWithNoTests 2>&1 | head -20"
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

# Copy CLAUDE.md template
cp "$SCRIPT_DIR/CLAUDE-cloudflare-template.md" ./CLAUDE.md 2>/dev/null || echo "# $PROJECT_NAME

## Overview
Cloudflare Workers project.

## Commands
\`\`\`bash
npm run dev        # Start dev server
npm run build      # Build for production
npm run deploy     # Deploy to Cloudflare
npm run test       # Run tests
npm run lint       # Run linter
\`\`\`
" > ./CLAUDE.md

# Build the project
echo "🔨 Building project..."
npm run build

# Run initial tests
echo "🧪 Running tests..."
npm run test

echo ""
echo "✅ Project $PROJECT_NAME created successfully!"
echo ""
echo "📋 Next steps:"
echo "   cd $PROJECT_NAME"
echo "   npm run dev           # Start Wrangler dev server"
echo "   npm run test          # Run tests"
echo "   npm run deploy        # Deploy to Cloudflare"
echo ""
if [ "$INCLUDE_MCP" = true ]; then
  echo "🔧 MCP server configured!"
  echo "   Add to Claude Desktop config to test locally"
fi
echo ""
echo "🚀 Happy coding!"
