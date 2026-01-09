import { db } from "../../db/index.js";
import { userPreferences } from "../../db/schema/user_preferences/index.js";
import { eq } from "drizzle-orm";
import type { CreateUserPreferencesInput, UpdateUserPreferencesInput } from "./schema.js";

export class UserPreferencesService {
  async findByUserId(userId: string) {
    const [result] = await db
      .select()
      .from(userPreferences)
      .where(eq(userPreferences.userId, userId));

    return result || null;
  }

  async create(userId: string, data: CreateUserPreferencesInput) {
    const [newPreferences] = await db
      .insert(userPreferences)
      .values({
        ...data,
        userId,
      })
      .returning();

    return newPreferences;
  }

  async update(userId: string, data: UpdateUserPreferencesInput) {
    const [updated] = await db
      .update(userPreferences)
      .set({
        ...data,
        updatedAt: new Date(),
      })
      .where(eq(userPreferences.userId, userId))
      .returning();

    return updated || null;
  }

  async upsert(userId: string, data: CreateUserPreferencesInput) {
    const existing = await this.findByUserId(userId);
    
    if (existing) {
      return await this.update(userId, data);
    } else {
      return await this.create(userId, data);
    }
  }
}
