import type { Context } from "hono";
import type { HonoContext } from "../../../types/hono.js";
import { UserExperienceService } from "../../../domain/user-experiences/service.js";
import { updateUserExperienceSchema } from "../../../domain/user-experiences/schema.js";

const userExperienceService = new UserExperienceService();

export async function update(c: Context<HonoContext>) {
  const user = c.get("user");
  if (!user) {
    return c.json({ error: "Unauthorized" }, 401);
  }

  const id = c.req.param("id");
  if (!id) {
    return c.json({ error: "Experience ID is required" }, 400);
  }

  try {
    const body = await c.req.json();
    const validatedData = updateUserExperienceSchema.parse(body);

    const experience = await userExperienceService.update(id, user.id, validatedData);
    if (!experience) {
      return c.json({ error: "Experience not found" }, 404);
    }
    return c.json(experience);
  } catch (error: any) {
    if (error.name === "ZodError") {
      return c.json({ error: "Validation error", details: error.errors }, 400);
    }
    console.error("Failed to update user experience:", error);
    return c.json({ error: "Failed to update user experience" }, 500);
  }
}
