import type { Context } from "hono";
import type { HonoContext } from "../../../types/hono.js";
import { JobOfferService } from "../../../domain/job-offers/service.js";

const jobOfferService = new JobOfferService();

export async function getById(c: Context<HonoContext>) {
  const user = c.get("user");
  if (!user) {
    return c.json({ error: "Unauthorized" }, 401);
  }

  const id = c.req.param("id");

  try {
    const jobOffer = await jobOfferService.findById(id);

    if (!jobOffer) {
      return c.json({ error: "Job offer not found" }, 404);
    }

    if (jobOffer.createdByUserId !== user.id && !jobOffer.isPublic) {
      return c.json({ error: "Unauthorized" }, 403);
    }

    return c.json(jobOffer);
  } catch (error) {
    console.error("Failed to fetch job offer:", error);
    return c.json({ error: "Failed to fetch job offer" }, 500);
  }
}
