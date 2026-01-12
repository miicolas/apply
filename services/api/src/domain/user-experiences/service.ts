import { db } from "../../db/index.js";
import { userExperience } from "../../db/schema/user_experience/schema.js";
import { eq, and } from "drizzle-orm";
import type { CreateUserExperienceInput, UpdateUserExperienceInput } from "./schema.js";

export class UserExperienceService {
  async findAllByUserId(userId: string) {
    const experiences = await db
      .select()
      .from(userExperience)
      .where(eq(userExperience.userId, userId))
      .orderBy(userExperience.startDate);

    return experiences;
  }

  async findById(id: string, userId: string) {
    const [experience] = await db
      .select()
      .from(userExperience)
      .where(
        and(
          eq(userExperience.id, id),
          eq(userExperience.userId, userId)
        )
      );

    return experience || null;
  }

  async create(userId: string, data: CreateUserExperienceInput) {
    const [newExperience] = await db
      .insert(userExperience)
      .values({
        userId,
        title: data.title,
        company: data.company || null,
        description: data.description || null,
        startDate: data.startDate || null,
        endDate: data.endDate || null,
      })
      .returning();

    return newExperience;
  }

  async update(id: string, userId: string, data: UpdateUserExperienceInput) {
    const [updated] = await db
      .update(userExperience)
      .set({
        title: data.title,
        company: data.company || null,
        description: data.description || null,
        startDate: data.startDate || null,
        endDate: data.endDate || null,
        updatedAt: new Date(),
      })
      .where(
        and(
          eq(userExperience.id, id),
          eq(userExperience.userId, userId)
        )
      )
      .returning();

    return updated || null;
  }

  async delete(id: string, userId: string) {
    const [deleted] = await db
      .delete(userExperience)
      .where(
        and(
          eq(userExperience.id, id),
          eq(userExperience.userId, userId)
        )
      )
      .returning();

    return deleted || null;
  }
}
