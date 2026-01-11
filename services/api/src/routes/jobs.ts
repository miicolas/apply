import { Hono } from "hono";
import { zValidator } from "@hono/zod-validator";
import { z } from "zod";
import { tasks, runs } from "@trigger.dev/sdk/v3";
import type { analyzeJobOfferTask } from "../trigger/analyze-job-offer.js";
import type { HonoContext } from "../types/hono.js";
import { db } from "../db/index.js";
import { job } from "../db/schema/job/schema.js";

const jobsRouter = new Hono<HonoContext>();

const triggerAnalyzeSchema = z.object({
  url: z.string().url(),
});

// POST /api/jobs/analyze - Trigger job offer analysis
jobsRouter.post(
  "/analyze",
  zValidator("json", triggerAnalyzeSchema),
  async (c) => {
    const user = c.get("user");
    if (!user) {
      return c.json({ error: "Unauthorized" }, 401);
    }

    const { url } = c.req.valid("json");

    try {
      const handle = await tasks.trigger<typeof analyzeJobOfferTask>(
        "analyze-job-offer",
        {
          url,
          userId: user.id,
        },
        {
          tags: [`user_${user.id}`, "job-analysis"],
        }
      );

      await db.insert(job).values({
        id: crypto.randomUUID(),
        status: "pending",
        triggerId: handle.id,
      });

      return c.json({
        success: true,
        runId: handle.id,
      });
    } catch (error) {
      console.error("Failed to trigger job analysis:", error);
      return c.json({ error: "Failed to start job analysis" }, 500);
    }
  }
);

// GET /api/jobs/:runId/status - Get job status
jobsRouter.get("/:runId/status", async (c) => {
  const user = c.get("user");
  if (!user) {
    return c.json({ error: "Unauthorized" }, 401);
  }

  const runId = c.req.param("runId");

  try {
    const run = await runs.retrieve(runId);

    return c.json({
      status: run.status,
      metadata: run.metadata,
      output: run.status === "COMPLETED" ? run.output : null,
      error: run.status === "FAILED" ? run.error : null,
    });
  } catch (error) {
    console.error("Failed to get job status:", error);
    return c.json({ error: "Job not found" }, 404);
  }
});

export { jobsRouter };
