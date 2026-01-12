import type { Context } from "hono";
import type { HonoContext } from "../../../types/hono.js";
import { UserExperienceService } from "../../../domain/user-experiences/service.js";

const userExperienceService = new UserExperienceService();

export async function remove(c: Context<HonoContext>) {
  const user = c.get("user");
  if (!user) {
    return c.json({ error: "Unauthorized" }, 401);
  }

  const id = c.req.param("id");
  if (!id) {
    return c.json({ error: "Experience ID is required" }, 400);
  }

  try {
    const deleted = await userExperienceService.delete(id, user.id);
    if (!deleted) {
      return c.json({ error: "Experience not found" }, 404);
    }
    return c.json({ success: true });
  } catch (error) {
    console.error("Failed to delete user experience:", error);
    return c.json({ error: "Failed to delete user experience" }, 500);
  }
}
