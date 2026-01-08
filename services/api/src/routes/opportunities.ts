import { Hono } from "hono";
import type { HonoContext } from "../types/hono.js";
import { requireAuth } from "../middleware/requireAuth.js";
import { OpportunityService } from "../domain/opportunities/service.js";
import {
  createOpportunitySchema,
  updateStatusSchema,
} from "../domain/opportunities/schema.js";
import { z } from "zod";

const opportunitiesRouter = new Hono<HonoContext>();
const opportunityService = new OpportunityService();

// Apply auth middleware to all routes
opportunitiesRouter.use("*", requireAuth);

// GET /api/opportunities?status=new
opportunitiesRouter.get("/", async (c) => {
  const user = c.get("user")!;
  const status = c.req.query("status");

  const opportunities = await opportunityService.findAll(user.id, status);

  return c.json({ opportunities });
});

// GET /api/opportunities/:id
opportunitiesRouter.get("/:id", async (c) => {
  const user = c.get("user")!;
  const id = c.req.param("id");

  const result = await opportunityService.findById(user.id, id);

  if (!result) {
    return c.json({ error: "Opportunity not found" }, 404);
  }

  return c.json({ opportunity: result });
});

// POST /api/opportunities
opportunitiesRouter.post("/", async (c) => {
  const user = c.get("user")!;

  try {
    const body = await c.req.json();
    console.log('body', body)
    const validated = createOpportunitySchema.parse(body);

    const newOpportunity = await opportunityService.create(user.id, validated);

    return c.json({ opportunity: newOpportunity }, 201);
  } catch (error) {
    if (error instanceof z.ZodError) {
      return c.json({ error: "Validation error", details: error.issues }, 400);
    }
    return c.json({ error: "Failed to create opportunity" }, 500);
  }
});

// PUT /api/opportunities/:id/status
opportunitiesRouter.put("/:id/status", async (c) => {
  const user = c.get("user")!;
  const id = c.req.param("id");

  try {
    const body = await c.req.json();
    const validated = updateStatusSchema.parse(body);

    const updated = await opportunityService.updateStatus(
      user.id,
      id,
      validated.status
    );

    if (!updated) {
      return c.json({ error: "Opportunity not found" }, 404);
    }

    return c.json({ opportunity: updated });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return c.json({ error: "Validation error", details: error.issues }, 400);
    }
    return c.json({ error: "Failed to update opportunity" }, 500);
  }
});

// DELETE /api/opportunities/:id
opportunitiesRouter.delete("/:id", async (c) => {
  const user = c.get("user")!;
  const id = c.req.param("id");

  const deleted = await opportunityService.delete(user.id, id);

  if (!deleted) {
    return c.json({ error: "Opportunity not found" }, 404);
  }

  return c.json({ success: true });
});

export default opportunitiesRouter;
