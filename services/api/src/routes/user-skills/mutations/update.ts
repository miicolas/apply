import type { Context } from "hono";
import type { HonoContext } from "../../../types/hono.js";
import { UserSkillsService } from "../../../domain/user-skills/service.js";
import { updateUserSkillSchema } from "../../../domain/user-skills/schema.js";

const userSkillsService = new UserSkillsService();

export async function update(c: Context<HonoContext>) {
  const user = c.get("user");
  if (!user) {
    return c.json({ error: "Unauthorized" }, 401);
  }

  const id = c.req.param("id");
  if (!id) {
    return c.json({ error: "Skill ID is required" }, 400);
  }

  try {
    const body = await c.req.json();
    const validatedData = updateUserSkillSchema.safeParse(body);

    if (!validatedData.success) {
      return c.json(
        { error: "Invalid data", details: validatedData.error.issues },
        400
      );
    }

    const skill = await userSkillsService.update(
      user.id,
      id,
      validatedData.data
    );
    if (!skill) {
      return c.json({ error: "Skill not found" }, 404);
    }
    return c.json(skill);
  } catch (error) {
    return c.json({ error: "Failed to update user skill" }, 500);
  }
}
