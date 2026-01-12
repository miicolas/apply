import { Hono } from "hono";
import type { HonoContext } from "../../types/hono.js";
import { requireAuth } from "../../middleware/requireAuth.js";
import { getSkills } from "./queries/index.js";
import { createSkill, update, remove } from "./mutations/index.js";

export const userSkillsRouter = new Hono<HonoContext>();

// Apply auth middleware to all routes
userSkillsRouter.use("*", requireAuth);

// Queries
userSkillsRouter.get("/", getSkills);

// Mutations
userSkillsRouter.post("/", createSkill);
userSkillsRouter.put("/:id", update);
userSkillsRouter.delete("/:id", remove);

