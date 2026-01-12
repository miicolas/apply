import type { Context } from "hono";
import type { HonoContext } from "../../../types/hono.js";
import { UserExperienceService } from "../../../domain/user-experiences/service.js";

const userExperienceService = new UserExperienceService();

export async function getAll(c: Context<HonoContext>) {
  const user = c.get("user");
  if (!user) {
    return c.json({ error: "Unauthorized" }, 401);
  }

  try {
    const experiences = await userExperienceService.findAllByUserId(user.id);
    return c.json(experiences);
  } catch (error) {
    console.error("Failed to fetch user experiences:", error);
    return c.json({ error: "Failed to fetch user experiences" }, 500);
  }
}
