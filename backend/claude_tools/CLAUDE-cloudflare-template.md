# Project Name

## Overview

<!-- UPDATE: Describe your project here -->
Cloudflare Workers API/service built with TypeScript.

## Tech Stack

- **Runtime**: Cloudflare Workers (edge computing)
- **Language**: TypeScript (strict mode)
- **Validation**: Zod schemas
- **Testing**: Vitest
- **Build**: Wrangler CLI

## Commands

```bash
# Development
npm run dev              # Start Wrangler dev server
npm run build            # Compile TypeScript
npm run deploy           # Deploy to Cloudflare

# Testing
npm run test             # Run tests once
npm run test:watch       # Run tests in watch mode
npm run test:ui          # Open Vitest UI
npm run test:coverage    # Run with coverage report

# Code Quality
npm run lint             # ESLint check
npm run lint:fix         # ESLint auto-fix
npm run format           # Prettier format
npm run typecheck        # TypeScript validation
```

## Project Structure

```
src/
├── index.ts             # Main entry point (Worker fetch handler or MCP server)
├── types.ts             # TypeScript type definitions
├── validation.ts        # Zod schemas and error sanitization
├── tools/               # Tool implementations (for MCP) or route handlers
│   └── *.ts
└── utils/               # Utility functions
    └── *.ts

# Config files
├── wrangler.toml        # Cloudflare Workers config
├── tsconfig.json        # TypeScript config
├── vitest.config.ts     # Vitest config
├── eslint.config.js     # ESLint 9 flat config
└── .prettierrc          # Prettier config
```

## Development Workflow

### Before Committing

Run all checks that pre-commit hooks will enforce:

```bash
npm run typecheck    # TypeScript errors
npm run lint         # ESLint errors
npm run test         # All tests pass
```

### Test-Driven Development

1. **RED**: Write a failing test
2. **GREEN**: Write minimal code to pass
3. **REFACTOR**: Clean up while keeping tests green

## Code Conventions

### TypeScript

- Strict mode enabled - no `any` types
- Use `unknown` for truly unknown types, then narrow
- Define interfaces in `src/types.ts`
- Export type definitions alongside implementations

### Validation

All external inputs validated with Zod:

```typescript
import { z } from 'zod';

const InputSchema = z.object({
  name: z.string().min(1),
  value: z.number().positive(),
});

type Input = z.infer<typeof InputSchema>;
```

### Error Handling

- Return descriptive error messages
- Never throw uncaught exceptions from handlers
- Use `sanitizeError()` to redact sensitive data

```typescript
import { sanitizeError } from './validation';

try {
  // ... operation
} catch (error) {
  return { error: sanitizeError(error) };
}
```

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Files | kebab-case | `user-service.ts` |
| Classes | PascalCase | `UserService` |
| Functions/Variables | camelCase | `getUserById` |
| Constants | SCREAMING_SNAKE | `MAX_RETRIES` |
| Types/Interfaces | PascalCase | `UserProfile` |

## Testing

### Test Organization

```typescript
describe('featureName', () => {
  describe('success cases', () => {
    it('should handle valid input', () => {});
  });

  describe('error cases', () => {
    it('should reject invalid input', () => {});
  });

  describe('edge cases', () => {
    it('should handle empty values', () => {});
  });
});
```

### Running Specific Tests

```bash
npm run test -- --grep "pattern"     # Run tests matching pattern
npm run test -- src/tools/           # Run tests in directory
```

## Environment Variables

### Local Development

Create `.dev.vars` for local secrets:

```bash
API_KEY=your-api-key
DATABASE_URL=your-db-url
```

### Production

Set secrets via Wrangler:

```bash
wrangler secret put API_KEY
```

## Deployment

```bash
# Deploy to production
npm run deploy

# Deploy to staging (if configured)
wrangler deploy --env staging
```

## Troubleshooting

### TypeScript Errors

```bash
npm run typecheck  # See all type errors
```

### Test Failures

```bash
npm run test:ui    # Debug with Vitest UI
```

### Wrangler Issues

```bash
wrangler whoami    # Check authentication
wrangler tail      # View production logs
```

## Security

1. **Never commit credentials** - Use `.dev.vars` and Wrangler secrets
2. **Input validation** - All inputs validated with Zod
3. **Error sanitization** - Sensitive data redacted from responses
4. **Rate limiting** - Implement for public endpoints

## Claude Code Instructions

When working on this project:

1. **Read before editing** - Always read files before making changes
2. **Write tests** - New features require accompanying tests
3. **Run checks before commits** - Verify typecheck, lint, and tests pass
4. **Use conventional commits** - `feat:`, `fix:`, `docs:`, etc.
