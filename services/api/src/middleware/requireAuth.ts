import { Context, Next } from "hono";
import type { HonoContext } from "../types/hono.js";

export const requireAuth = async (c: Context<HonoContext>, next: Next) => {
  const user = c.get("user");

  if (!user) {
    return c.json({ error: "Unauthorized" }, 401);
  }

  await next();
};
