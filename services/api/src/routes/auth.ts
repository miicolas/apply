import { Context } from "hono";
import { auth } from "../config/auth";
import type { HonoContext } from "../types/hono";

export const authHandler = async (c: Context<HonoContext>) => {
    try {
        // Better Auth handles everything natively, including Bearer token plugin
        return await auth.handler(c.req.raw);
    } catch (error) {
        console.error(`❌ [AuthHandler] Erreur:`, error);
        throw error;
    }
};
