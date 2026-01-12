import { Hono } from "hono";
import type { HonoContext } from "../../types/hono.js";
import { requireAuth } from "../../middleware/requireAuth.js";
import { getPreferences } from "./queries/index.js";
import { upsert } from "./mutations/index.js";

const userPreferencesRouter = new Hono<HonoContext>();

// Apply auth middleware to all routes
userPreferencesRouter.use("*", requireAuth);

// Queries
userPreferencesRouter.get("/", getPreferences);

// Mutations
userPreferencesRouter.put("/", upsert);

export { userPreferencesRouter };
