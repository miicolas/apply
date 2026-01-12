import { HonoContext } from "@/src/types/hono";
import { Context } from "hono";
import { UserSkillsService } from "../../../domain/user-skills/service";
import { createUserSkillSchema } from "../../../domain/user-skills/schema";
const userSkillsService = new UserSkillsService();

export async function createSkill(c: Context<HonoContext>) {
  const user = c.get("user");

  const data = await c.req.json();
  if (!user) {
    return c.json({ error: "Unauthorized" }, 401);
  }

  try {
    const validatedData = createUserSkillSchema.safeParse(data);
    if (!validatedData.success) {
      return c.json({ error: "Invalid data" }, 400);
    }
    const skill = await userSkillsService.create(user.id, validatedData.data);
    if (!skill) {
      return c.json({ error: "Failed to create skill" }, 500);
    }
    return c.json(skill, 201);
  } catch (error) {
    console.error("Failed to create skill:", error);
    return c.json({ error: "Failed to create skill" }, 500);
  }
}