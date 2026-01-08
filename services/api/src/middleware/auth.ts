import { Context, Next } from "hono";
import { auth } from "../../auth.js";
import type { HonoContext } from "../types/hono";

export const authMiddleware = async (c: Context<HonoContext>, next: Next) => {
    // #region agent log
    const cookieHeader = c.req.raw.headers.get("cookie") || "none";
    const logData1 = {
        location: "auth.ts:6",
        message: "authMiddleware - Headers reçus",
        data: {
            path: c.req.path,
            cookieHeader: cookieHeader.substring(0, 100),
            hasCookie: cookieHeader !== "none"
        },
        timestamp: Date.now(),
        sessionId: "debug-session",
        runId: "run1",
        hypothesisId: "A"
    };
    fetch('http://127.0.0.1:7243/ingest/cf0b29dd-8f52-46ec-9251-04ab30e5e6b9', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(logData1)
    }).catch(() => {});
    // #endregion
    
    const session = await auth.api.getSession({ headers: c.req.raw.headers });

    // #region agent log
    const logData2 = {
        location: "auth.ts:7",
        message: "authMiddleware - Session récupérée",
        data: {
            path: c.req.path,
            hasSession: session !== null,
            userId: session?.user?.id || "nil"
        },
        timestamp: Date.now(),
        sessionId: "debug-session",
        runId: "run1",
        hypothesisId: "B"
    };
    fetch('http://127.0.0.1:7243/ingest/cf0b29dd-8f52-46ec-9251-04ab30e5e6b9', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(logData2)
    }).catch(() => {});
    // #endregion

    if (!session) {
        c.set("user", null);
        c.set("session", null);
        await next();
        return;
    }

    c.set("user", session.user);
    c.set("session", session.session);
    await next();
};
