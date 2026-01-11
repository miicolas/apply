import { Hono } from "hono";
import { serve } from "@hono/node-server";
import { authMiddleware, corsMiddleware } from "./middleware/index.js";
import { authHandler, sessionHandler, jobsRouter, jobOffersRouter } from "./routes/index.js";
import type { HonoContext } from "./types/hono.js";
import { logger } from 'hono/logger'

const app = new Hono<HonoContext>();

app.use('*', logger())

app.use("*", corsMiddleware);

app.use("/api/auth/*", async (c, next) => {
    const origin = c.req.header("origin");
    const userAgent = c.req.header("user-agent") || "";
    const isIOSApp = userAgent.includes("CFNetwork") || userAgent.includes("Darwin");
    
    if (!origin && isIOSApp) {
        const headers = new Headers(c.req.raw.headers);
        headers.set("origin", "apply://");
        
        const clonedReq = c.req.raw.clone();
        const bodyText = await clonedReq.text().catch(() => "");
        
        const newRequest = new Request(c.req.url, {
            method: c.req.method,
            headers: headers,
            body: bodyText || null,
        });
        
        Object.defineProperty(c.req, 'raw', {
            value: newRequest,
            writable: true,
            configurable: true,
        });
    }
    
    await next();
});

app.use("*", authMiddleware);

app.on(["POST", "GET"], "/api/auth/*", authHandler);

app.get("/session", sessionHandler);
app.get("/api/auth/session", sessionHandler);

// Routes
app.route("/api/jobs", jobsRouter);
app.route("/api/job-offers", jobOffersRouter);

// Routes will be added here:
// app.route("/api/applications", applicationsRouter);
// app.route("/api/user-preferences", userPreferencesRouter);

const port = Number(process.env.PORT) || 3000;
const hostname = process.env.HOSTNAME || "0.0.0.0";

serve({
    fetch: app.fetch,
    port,
    hostname,
});