import { db } from "../../db/index.js";
import { userSkill } from "../../db/schema/user_skill/schema.js";
import { and, eq } from "drizzle-orm";
import type { CreateUserSkillInput, UpdateUserSkillInput } from "./schema.js";

export class UserSkillsService {
  async findByUserId(id: string) {
    const userSkills = await db
      .select()
      .from(userSkill)
      .where(eq(userSkill.userId, id));

    return userSkills;
  }

  async create(userId: string, data: CreateUserSkillInput) {

    const [newSkill] = await db
      .insert(userSkill)
      .values({
        ...data,
        userId,
      })
      .returning();

    if (!newSkill) {
      return null;
    }

    return newSkill;
  }

  async update(userId: string, id: string, data: UpdateUserSkillInput) {

    const [updatedSkill] = await db
      .update(userSkill)
      .set({
        ...data,
        updatedAt: new Date(),
      })
      .where(and(eq(userSkill.userId, userId), eq(userSkill.id, id)))
      .returning();

    if (!updatedSkill) {
      return null;
    }

    return updatedSkill;
  }

  async delete(userId: string, id: string) {

    const [deletedSkill] = await db
      .delete(userSkill)
      .where(and(eq(userSkill.userId, userId), eq(userSkill.id, id)))
      .returning();


    if (!deletedSkill) {
      return null;
    }

    return deletedSkill;
  }

}
