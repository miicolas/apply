import { Hono } from "hono";
import type { HonoContext } from "../../types/hono.js";
import { requireAuth } from "../../middleware/requireAuth.js";
import { getAll, getById } from "./queries/index.js";
import { create, update, remove } from "./mutations/index.js";

const userExperiencesRouter = new Hono<HonoContext>();

// Apply auth middleware to all routes
userExperiencesRouter.use("*", requireAuth);

// Queries
userExperiencesRouter.get("/", getAll);
userExperiencesRouter.get("/:id", getById);

// Mutations
userExperiencesRouter.post("/", create);
userExperiencesRouter.put("/:id", update);
userExperiencesRouter.delete("/:id", remove);

export { userExperiencesRouter };
