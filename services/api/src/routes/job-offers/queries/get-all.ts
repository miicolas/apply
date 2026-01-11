import type { Context } from "hono";
import type { HonoContext } from "../../../types/hono.js";
import { JobOfferService } from "../../../domain/job-offers/service.js";

const jobOfferService = new JobOfferService();

export async function getAll(c: Context<HonoContext>) {
  const user = c.get("user");
  if (!user) {
    return c.json({ error: "Unauthorized" }, 401);
  }

  try {
    const jobOffers = await jobOfferService.findAll(user.id);
    console.log(jobOffers, "jobOffers");
    return c.json(jobOffers);
  } catch (error) {
    console.error("Failed to fetch job offers:", error);
    return c.json({ error: "Failed to fetch job offers" }, 500);
  }
}
