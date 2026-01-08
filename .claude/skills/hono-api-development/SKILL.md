---
name: hono-api-development
description: Develop professional REST APIs with Hono framework. Use when creating API endpoints, middleware, validation, error handling, or discussing API architecture with Hono.
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
---

# Hono API Development Standards

Professional guidelines for building production-ready REST APIs with Hono framework.

## Core Principles

1. **Type Safety**: Leverage TypeScript strict mode and Hono's type inference
2. **Security First**: Authentication, input validation, and CORS on all endpoints
3. **RESTful Design**: Follow REST conventions for predictable APIs
4. **Error Handling**: Consistent error responses with appropriate HTTP codes
5. **Separation of Concerns**: Modular architecture (routes, middleware, services)

## Standard Project Structure

```
src/
├── index.ts              # Application entry point
├── routes/               # Route handlers organized by resource
├── middleware/           # Reusable middleware
├── services/             # Business logic layer
├── validators/           # Request validation schemas
└── types/                # TypeScript type definitions
```

## RESTful Route Conventions

### Standard HTTP Methods

| Method   | Purpose              | Endpoint Example           | Response Code |
|----------|---------------------|----------------------------|---------------|
| GET      | Retrieve resource(s)| `/api/users`              | 200           |
| POST     | Create new resource | `/api/users`              | 201           |
| PUT      | Replace resource    | `/api/users/:id`          | 200           |
| PATCH    | Update resource     | `/api/users/:id`          | 200           |
| DELETE   | Remove resource     | `/api/users/:id`          | 204           |

### Route Handler Pattern

```typescript
import { Hono } from 'hono'
import { zValidator } from '@hono/zod-validator'
import { z } from 'zod'

const app = new Hono()

// List resources
app.get('/', async (c) => {
  const items = await service.findAll()
  return c.json({ data: items })
})

// Get single resource
app.get('/:id', async (c) => {
  const id = c.req.param('id')
  const item = await service.findById(id)

  if (!item) {
    return c.json({ error: 'Not found' }, 404)
  }

  return c.json({ data: item })
})

// Create resource
const createSchema = z.object({
  name: z.string().min(1),
  email: z.string().email()
})

app.post('/', zValidator('json', createSchema), async (c) => {
  const body = c.req.valid('json')
  const item = await service.create(body)
  return c.json({ data: item }, 201)
})

// Update resource
app.patch('/:id', zValidator('json', updateSchema), async (c) => {
  const id = c.req.param('id')
  const body = c.req.valid('json')
  const item = await service.update(id, body)
  return c.json({ data: item })
})

// Delete resource
app.delete('/:id', async (c) => {
  const id = c.req.param('id')
  await service.delete(id)
  return c.body(null, 204)
})

export default app
```

## Middleware Patterns

### Authentication Middleware

```typescript
import { Context, Next } from 'hono'

export async function requireAuth(c: Context, next: Next) {
  const token = c.req.header('Authorization')?.replace('Bearer ', '')

  if (!token) {
    return c.json({ error: 'Unauthorized' }, 401)
  }

  try {
    const user = await verifyToken(token)
    c.set('user', user)
    await next()
  } catch (error) {
    return c.json({ error: 'Invalid token' }, 401)
  }
}
```

### Error Handler

```typescript
import { ErrorHandler } from 'hono'

export const errorHandler: ErrorHandler = (err, c) => {
  console.error('Error:', err)

  if (err instanceof ValidationError) {
    return c.json({ error: err.message }, 400)
  }

  return c.json({ error: 'Internal server error' }, 500)
}
```

### CORS Configuration

```typescript
import { cors } from 'hono/cors'

app.use('*', cors({
  origin: ['https://yourdomain.com'],
  allowMethods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE'],
  allowHeaders: ['Content-Type', 'Authorization'],
  credentials: true
}))
```

## Request Validation with Zod

```typescript
import { z } from 'zod'
import { zValidator } from '@hono/zod-validator'

// Define validation schema
const userSchema = z.object({
  name: z.string().min(1).max(100),
  email: z.string().email(),
  age: z.number().int().positive().optional()
})

// Use in route
app.post('/users', zValidator('json', userSchema), async (c) => {
  const data = c.req.valid('json') // Typed and validated
  // Process data...
})

// Query parameter validation
const querySchema = z.object({
  page: z.string().transform(Number).pipe(z.number().min(1)).default('1'),
  limit: z.string().transform(Number).pipe(z.number().max(100)).default('20')
})

app.get('/users', zValidator('query', querySchema), async (c) => {
  const { page, limit } = c.req.valid('query')
  // Use pagination...
})
```

## Response Format Standards

### Success Response

```typescript
// Single resource
{
  "data": {
    "id": "123",
    "name": "John Doe"
  }
}

// Collection
{
  "data": [
    { "id": "1", "name": "Item 1" },
    { "id": "2", "name": "Item 2" }
  ],
  "meta": {
    "total": 50,
    "page": 1,
    "limit": 20
  }
}
```

### Error Response

```typescript
{
  "error": {
    "message": "Resource not found",
    "code": "NOT_FOUND"
  }
}

// With validation errors
{
  "error": {
    "message": "Validation failed",
    "code": "VALIDATION_ERROR",
    "details": [
      { "field": "email", "message": "Invalid email format" }
    ]
  }
}
```

## Application Setup

```typescript
import { Hono } from 'hono'
import { logger } from 'hono/logger'
import { cors } from 'hono/cors'

const app = new Hono()

// Global middleware
app.use('*', logger())
app.use('*', cors())

// Health check
app.get('/health', (c) => c.json({ status: 'ok' }))

// API routes
app.route('/api/users', usersRouter)
app.route('/api/posts', postsRouter)

// 404 handler
app.notFound((c) => c.json({ error: 'Route not found' }, 404))

// Error handler
app.onError((err, c) => {
  console.error(err)
  return c.json({ error: 'Internal server error' }, 500)
})

export default app
```

## Security Best Practices

- ✅ Validate all input with Zod
- ✅ Use parameterized queries (prepared statements)
- ✅ Implement rate limiting
- ✅ Sanitize user input
- ✅ Set secure headers (helmet)
- ✅ Use HTTPS in production
- ✅ Never expose stack traces to clients
- ✅ Implement proper CORS policies
- ✅ Hash passwords with bcrypt
- ✅ Use environment variables for secrets

## Testing Pattern

```typescript
import { describe, it, expect } from 'vitest'
import app from './index'

describe('API Tests', () => {
  it('should return 401 without auth', async () => {
    const res = await app.request('/api/protected')
    expect(res.status).toBe(401)
  })

  it('should create resource', async () => {
    const res = await app.request('/api/users', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer token'
      },
      body: JSON.stringify({ name: 'Test User' })
    })

    expect(res.status).toBe(201)
    const data = await res.json()
    expect(data.data).toHaveProperty('id')
  })
})
```

## HTTP Status Code Reference

| Code | Meaning              | Usage                                    |
|------|----------------------|------------------------------------------|
| 200  | OK                   | Successful GET, PUT, PATCH              |
| 201  | Created              | Successful POST                         |
| 204  | No Content           | Successful DELETE                       |
| 400  | Bad Request          | Invalid input/validation error          |
| 401  | Unauthorized         | Missing or invalid authentication       |
| 403  | Forbidden            | Authenticated but not authorized        |
| 404  | Not Found            | Resource doesn't exist                  |
| 409  | Conflict             | Duplicate resource                      |
| 422  | Unprocessable Entity | Valid syntax but semantic error         |
| 500  | Internal Error       | Server error                            |

## Performance Tips

- Use streaming for large responses
- Implement caching strategies
- Add database indexes
- Use connection pooling
- Enable gzip compression
- Implement pagination for collections
- Add request timeouts

## Quick Reference Commands

```bash
# Initialize Hono project
npm create hono@latest

# Install common dependencies
npm install hono @hono/zod-validator zod

# Run development server
npm run dev

# Run tests
npm test

# Type checking
npm run typecheck
```

## Additional Resources

- [Hono Documentation](https://hono.dev)
- [Zod Documentation](https://zod.dev)
- [REST API Best Practices](https://restfulapi.net)
