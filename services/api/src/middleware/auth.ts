import { Context, Next } from "hono";
import { auth } from "../config/auth.js";
import type { HonoContext } from "../types/hono";

export const authMiddleware = async (c: Context<HonoContext>, next: Next) => {
    const authHeader = c.req.header("Authorization");
    
    const session = await auth.api.getSession({ headers: c.req.raw.headers });

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
