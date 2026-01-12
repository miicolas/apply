import type { Context } from "hono";
import type { HonoContext } from "../../../types/hono.js";
import { UserSkillsService } from "../../../domain/user-skills/service.js";

const userSkillsService = new UserSkillsService();

export async function remove(c: Context<HonoContext>) {
  const user = c.get("user");
  if (!user) {
    return c.json({ error: "Unauthorized" }, 401);
  }

  const id = c.req.param("id");
  if (!id) {
    return c.json({ error: "Skill ID is required" }, 400);
  }

  try {
    const deleted = await userSkillsService.delete(user.id, id);
    if (!deleted) {
      return c.json({ error: "Skill not found" }, 404);
    }
    return c.json({ success: true });
  } catch (error) {
    console.error("Failed to delete user skill:", error);
    return c.json({ error: "Failed to delete user skill" }, 500);
  }
}
