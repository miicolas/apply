import { Context } from "hono";
import type { HonoContext } from "../../../types/hono.js";
import { UserSkillsService } from "../../../domain/user-skills/service.js";

const userSkillsService = new UserSkillsService();

export async function getSkills(c: Context<HonoContext>) {
  const user = c.get("user");
  if (!user) {
    return c.json({ error: "Unauthorized" }, 401);
  }

  try {
    const skills = await userSkillsService.findByUserId(user.id);
    return c.json(skills);
  } catch (error) {
    console.error("Failed to fetch skills:", error);
    return c.json({ error: "Failed to fetch skills" }, 500);
  }
}
