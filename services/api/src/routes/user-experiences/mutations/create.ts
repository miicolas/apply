import type { Context } from "hono";
import type { HonoContext } from "../../../types/hono.js";
import { UserExperienceService } from "../../../domain/user-experiences/service.js";
import { createUserExperienceSchema } from "../../../domain/user-experiences/schema.js";

const userExperienceService = new UserExperienceService();

export async function create(c: Context<HonoContext>) {
  const user = c.get("user");
  if (!user) {
    return c.json({ error: "Unauthorized" }, 401);
  }

  try {
    const body = await c.req.json();
    const validatedData = createUserExperienceSchema.parse(body);

    const experience = await userExperienceService.create(user.id, validatedData);
    return c.json(experience, 201);
  } catch (error: any) {
    if (error.name === "ZodError") {
      return c.json({ error: "Validation error", details: error.errors }, 400);
    }
    console.error("Failed to create user experience:", error);
    return c.json({ error: "Failed to create user experience" }, 500);
  }
}
