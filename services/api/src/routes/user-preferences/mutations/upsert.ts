import type { Context } from "hono";
import type { HonoContext } from "../../../types/hono.js";
import { UserPreferencesService } from "../../../domain/user-preferences/service.js";
import { updateUserPreferencesSchema } from "../../../domain/user-preferences/schema.js";

const userPreferencesService = new UserPreferencesService();

export async function upsert(c: Context<HonoContext>) {
  const user = c.get("user");
  if (!user) {
    return c.json({ error: "Unauthorized" }, 401);
  }

  try {
    const body = await c.req.json();
    const validatedData = updateUserPreferencesSchema.safeParse(body);

    if (!validatedData.success) {
      return c.json(
        { error: "Invalid data", details: validatedData.error.issues },
        400
      );
    }

    const preferences = await userPreferencesService.upsert(
      user.id,
      validatedData.data
    );

    return c.json(preferences);
  } catch (error) {
    console.error("Failed to upsert user preferences:", error);
    return c.json({ error: "Failed to update user preferences" }, 500);
  }
}
