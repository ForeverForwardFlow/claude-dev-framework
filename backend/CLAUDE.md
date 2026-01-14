# Backend Development Standards

This directory contains backend projects following a standardized development approach. All projects should adhere to these guidelines for consistency and maintainability.

## Technology Stack

### Core Technologies

- **Runtime**: Cloudflare Workers (edge computing)
- **Language**: TypeScript with strict mode
- **Build**: Wrangler for Cloudflare Workers deployment
- **Test Framework**: Vitest

### Development Tools

- **Package Manager**: npm with workspaces (for monorepos)
- **Linting**: ESLint 9 with flat config
- **Formatting**: Prettier
- **Git Hooks**: Husky + lint-staged
- **Build Orchestration**: Turborepo (for monorepos)

## Project Structure

### Single-Package Projects

```
project-name/
├── src/
│   ├── index.ts           # Main entry point
│   ├── types.ts           # TypeScript type definitions
│   ├── services/          # Business logic modules
│   └── utils/             # Utility functions
├── tests/
│   ├── unit/              # Unit tests
│   ├── integration/       # Integration tests
│   └── e2e/               # End-to-end tests
├── .dev.vars              # Local environment variables (gitignored)
├── .gitignore
├── package.json
├── tsconfig.json
├── vitest.config.ts
├── wrangler.toml          # Cloudflare Workers config
└── CLAUDE.md              # Project-specific guidance
```

### Monorepo Projects

```
project-name/
├── package-a/
│   ├── src/
│   ├── package.json
│   └── tsconfig.json
├── package-b/
│   └── ...
├── shared/                 # Shared utilities
├── package.json            # Root workspace config
├── turbo.json              # Turborepo task config
├── eslint.config.js        # Shared ESLint config
├── .prettierrc             # Shared Prettier config
└── CLAUDE.md
```

## Code Conventions

### TypeScript

- Use strict mode (`"strict": true` in tsconfig.json)
- Prefer interfaces over type aliases for object shapes
- Use explicit return types for exported functions
- Avoid `any` - use `unknown` when type is uncertain
- Prefix unused parameters with underscore (`_param`)

### Async/Await

- Always use async/await over raw Promises
- Avoid sync file I/O operations
- Handle errors with try/catch at appropriate boundaries

### Naming Conventions

- **Files**: kebab-case (`tool-executor.ts`)
- **Classes**: PascalCase (`ToolExecutor`)
- **Functions/Variables**: camelCase (`executeToolCall`)
- **Constants**: SCREAMING_SNAKE_CASE (`MAX_RETRIES`)
- **Types/Interfaces**: PascalCase (`ToolDefinition`)

## Testing Requirements

### Test Coverage

- Write tests for all new features
- Tests should accompany implementation, not be an afterthought
- Aim for meaningful coverage, not arbitrary percentages

### Test Organization

```typescript
// tool-name.test.ts
import { describe, it, expect, vi } from 'vitest';

describe('toolName', () => {
  describe('success cases', () => {
    it('should handle valid input', async () => {
      // ...
    });
  });

  describe('error cases', () => {
    it('should reject invalid input', async () => {
      // ...
    });
  });

  describe('edge cases', () => {
    it('should handle empty values', async () => {
      // ...
    });
  });
});
```

### Mocking

- Use Vitest's `vi.mock()` for module mocking
- Mock external APIs and services in tests
- Use MSW (Mock Service Worker) for HTTP mocking when appropriate

## Linting & Formatting

### ESLint Configuration

Use ESLint 9 flat config with TypeScript support:

```javascript
// eslint.config.js
import eslint from '@eslint/js';
import tseslint from 'typescript-eslint';
import eslintConfigPrettier from 'eslint-config-prettier';

export default tseslint.config(
  {
    ignores: ['**/dist/**', '**/node_modules/**', '**/coverage/**'],
  },
  eslint.configs.recommended,
  ...tseslint.configs.recommended,
  eslintConfigPrettier,
  {
    files: ['**/*.ts'],
    rules: {
      '@typescript-eslint/no-unused-vars': [
        'error',
        { argsIgnorePattern: '^_', varsIgnorePattern: '^_' },
      ],
      '@typescript-eslint/no-explicit-any': 'warn',
      'prefer-const': 'error',
      'no-var': 'error',
      eqeqeq: ['error', 'always', { null: 'ignore' }],
    },
  }
);
```

### Prettier Configuration

```json
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
```

## Pre-Commit Hooks

### Husky + lint-staged Setup

```json
// package.json
{
  "scripts": {
    "prepare": "husky"
  },
  "lint-staged": {
    "*.{ts,tsx,js,jsx}": ["eslint --fix", "prettier --write"],
    "*.{json,md,yml,yaml}": ["prettier --write"]
  }
}
```

### Pre-Commit Hook

```bash
# .husky/pre-commit
npm run lint-staged
npm run test
```

## Validation Patterns

### Input Validation with Zod

```typescript
import { z } from 'zod';

const InputSchema = z.object({
  name: z.string().min(1),
  email: z.string().email(),
  age: z.number().int().positive().optional(),
});

type Input = z.infer<typeof InputSchema>;

function processInput(raw: unknown): Input {
  return InputSchema.parse(raw);
}
```

### Error Handling

- Return descriptive error messages
- Never throw uncaught exceptions from tool handlers
- Sanitize sensitive data from error messages (tokens, emails, paths)

```typescript
function sanitizeError(error: unknown): string {
  const message = error instanceof Error ? error.message : String(error);
  return message
    .replace(/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/g, '[email]')
    .replace(/Bearer\s+[A-Za-z0-9-._~+/]+=*/g, 'Bearer [token]')
    .replace(/access_token=[^&\s]+/g, 'access_token=[redacted]');
}
```

## Security Practices

1. **Never commit credentials** - Use `.dev.vars` for local secrets, gitignore all credential files
2. **Input validation** - Validate all external inputs with Zod schemas
3. **Error sanitization** - Redact sensitive data before returning errors
4. **Rate limiting** - Protect API endpoints from abuse
5. **Secure file permissions** - Token files should use 0o600 permissions

## Commit Conventions

Use [Conventional Commits](https://www.conventionalcommits.org/) format:

- `feat:` new feature
- `fix:` bug fix
- `docs:` documentation only
- `refactor:` code change that neither fixes nor adds
- `test:` adding or updating tests
- `chore:` maintenance tasks

Examples:
```
feat(auth): add OAuth2 token refresh
fix: handle empty response from API
refactor(tools): extract common validation logic
test: add edge case coverage for calculator
```

## Development Workflow

### Before Starting Work

1. Ensure dependencies are installed: `npm install`
2. Run existing tests to verify setup: `npm test`
3. Start dev server if applicable: `npm run dev`

### Before Committing

Run all checks that pre-commit hooks will enforce:

```bash
npm run lint       # ESLint - fix any errors
npm run format     # Prettier - auto-formats code
npm run typecheck  # TypeScript - catch type errors (if available)
npm run test       # Full test suite - must pass
```

### After Making Changes

If lint/typecheck/test failures require code changes, re-run the full test suite before committing - changes can introduce new issues.

## Claude Code Instructions

When working on projects in this directory:

1. **Read before editing** - Always read files before making changes
2. **Write tests** - New features require accompanying tests
3. **Use subagents** for complex tasks:
   - `Explore` for codebase exploration
   - `test-engineer` for writing test suites
   - `code-reviewer` for reviewing implementations
   - `implementer` for focused implementation tasks
4. **Run checks before commits** - Verify lint, format, typecheck, and tests pass
5. **Follow project-specific CLAUDE.md** - Individual projects may have additional guidance

## Package.json Scripts (Standard)

```json
{
  "scripts": {
    "dev": "wrangler dev",
    "deploy": "wrangler deploy",
    "build": "tsc",
    "test": "vitest run",
    "test:watch": "vitest",
    "test:coverage": "vitest run --coverage",
    "lint": "eslint .",
    "lint:fix": "eslint . --fix",
    "format": "prettier --write .",
    "format:check": "prettier --check .",
    "typecheck": "tsc --noEmit",
    "prepare": "husky"
  }
}
```

## Cloudflare Workers Specifics

### Durable Objects

- Use for stateful WebSocket connections
- Store configuration in `ctx.storage` for persistence
- Handle hibernation for long-running connections

### Environment Variables

- Local: `.dev.vars` file
- Production: Wrangler secrets (`wrangler secret put KEY`)
- Access via `env` parameter in handlers

### WebSocket Handling

```typescript
async fetch(request: Request, env: Env): Promise<Response> {
  const upgradeHeader = request.headers.get('Upgrade');
  if (upgradeHeader === 'websocket') {
    const pair = new WebSocketPair();
    // Handle WebSocket...
    return new Response(null, { status: 101, webSocket: pair[0] });
  }
  // Handle HTTP...
}
```

## Dependencies (Recommended)

### Core
- `typescript` - TypeScript compiler
- `wrangler` - Cloudflare Workers CLI
- `@cloudflare/workers-types` - TypeScript types for Workers

### Testing
- `vitest` - Test framework
- `@vitest/coverage-v8` - Coverage reporting
- `msw` - HTTP request mocking

### Code Quality
- `eslint` - Linting
- `@typescript-eslint/eslint-plugin` - TypeScript ESLint rules
- `prettier` - Code formatting
- `husky` - Git hooks
- `lint-staged` - Run linters on staged files

### Validation
- `zod` - Schema validation (recommended)
