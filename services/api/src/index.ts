import { Hono } from "hono";
import { serve } from "@hono/node-server";
import { authMiddleware, corsMiddleware } from "./middleware/index.js";
import { authHandler, sessionHandler } from "./routes/index.js";
import type { HonoContext } from "./types/hono.js";

const app = new Hono<HonoContext>();

// CORS middleware must be registered before routes
app.use("*", corsMiddleware);

// Auth middleware to populate user and session in context
app.use("*", authMiddleware);

// Auth routes
app.on(["POST", "GET"], "/api/auth/*", authHandler);

// Session routes (custom endpoint and Better Auth endpoint)
app.get("/session", sessionHandler);
app.get("/api/auth/session", sessionHandler);

const port = Number(process.env.PORT) || 3000;
const hostname = process.env.HOSTNAME || "0.0.0.0";
console.log(`🚀 Server running on http://${hostname}:${port}`);

serve({
    fetch: app.fetch,
    port,
    hostname, // Écouter sur toutes les interfaces pour permettre les connexions depuis les appareils iOS
});