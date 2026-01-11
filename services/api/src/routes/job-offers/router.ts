import { Hono } from "hono";
import type { HonoContext } from "../../types/hono.js";
import { getAll, getById } from "./queries/index.js";

const jobOffersRouter = new Hono<HonoContext>();

// Queries
jobOffersRouter.get("/", getAll);
jobOffersRouter.get("/:id", getById);

// Mutations will be added here
// jobOffersRouter.post("/", create);
// jobOffersRouter.put("/:id", update);
// jobOffersRouter.delete("/:id", remove);

export { jobOffersRouter };
