import { Context } from "hono";
import type { HonoContext } from "../types/hono.js";

export const sessionHandler = (c: Context<HonoContext>) => {
    console.log(`📋 [SessionHandler] Requête de session`);
    
    const session = c.get("session");
    const user = c.get("user");

    if (!user || !session) {
        console.log(`❌ [SessionHandler] Session ou utilisateur manquant`);
        return c.body(null, 401);
    }

    console.log(`✅ [SessionHandler] Session retournée pour: ${user.email}`);
    return c.json({
        session,
        user,
    });
};
