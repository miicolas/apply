import type { Context } from "hono";
import type { HonoContext } from "../../../types/hono.js";
import { UserPreferencesService } from "../../../domain/user-preferences/service.js";

const userPreferencesService = new UserPreferencesService();

export async function getPreferences(c: Context<HonoContext>) {
  const user = c.get("user");
  if (!user) {
    return c.json({ error: "Unauthorized" }, 401);
  }

  try {
    const preferences = await userPreferencesService.findByUserId(user.id);
    return c.json(preferences);
  } catch (error) {
    console.error("Failed to get user preferences:", error);
    return c.json({ error: "Failed to get user preferences" }, 500);
  }
}
