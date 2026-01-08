import { Context } from "hono";
import { auth } from "../../auth.js";
import type { HonoContext } from "../types/hono.js";

export const authHandler = (c: Context<HonoContext>) => {
    return auth.handler(c.req.raw);
};
