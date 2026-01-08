import { Context } from "hono";
import type { HonoContext } from "../types/hono.js";

export const sessionHandler = (c: Context<HonoContext>) => {
    const session = c.get("session");
    const user = c.get("user");

    // #region agent log
    const logData = {
        location: "session.ts:4",
        message: "sessionHandler - Données session",
        data: {
            path: c.req.path,
            hasUser: user !== null,
            hasSession: session !== null,
            userId: user?.id || "nil"
        },
        timestamp: Date.now(),
        sessionId: "debug-session",
        runId: "run1",
        hypothesisId: "C"
    };
    fetch('http://127.0.0.1:7243/ingest/cf0b29dd-8f52-46ec-9251-04ab30e5e6b9', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(logData)
    }).catch(() => {});
    // #endregion

    if (!user) {
        return c.body(null, 401);
    }

    return c.json({
        session,
        user,
    });
};
