import { Hono } from "hono";
import type { HonoContext } from "../../types/hono.js";
import { getAll, getById } from "./queries/index";

export const jobOffersRouter = new Hono<HonoContext>();

// Queries
jobOffersRouter.get("/", getAll);
jobOffersRouter.get("/:id", getById);   
