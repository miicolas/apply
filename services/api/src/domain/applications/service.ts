import { db } from "../../db/index.js";
import { application, type ApplicationStatus } from "../../db/schema/application/index.js";
import { eq, and, desc } from "drizzle-orm";
import type { CreateApplicationInput, UpdateApplicationInput } from "./schema.js";

export class ApplicationService {
  async findAll(userId: string, status?: ApplicationStatus) {
    const conditions = [eq(application.userId, userId)];

    if (status) {
      conditions.push(eq(application.status, status));
    }

    return await db
      .select()
      .from(application)
      .where(and(...conditions))
      .orderBy(desc(application.createdAt));
  }

  async findById(userId: string, id: string) {
    const [result] = await db
      .select()
      .from(application)
      .where(and(eq(application.id, id), eq(application.userId, userId)));

    return result || null;
  }

  async findByJobOfferId(userId: string, jobOfferId: string) {
    const [result] = await db
      .select()
      .from(application)
      .where(
        and(
          eq(application.userId, userId),
          eq(application.jobOfferId, jobOfferId)
        )
      );

    return result || null;
  }

  async create(userId: string, data: CreateApplicationInput) {
    const [newApplication] = await db
      .insert(application)
      .values({
        ...data,
        userId,
      })
      .returning();

    return newApplication;
  }

  async update(userId: string, id: string, data: UpdateApplicationInput) {
    const updateData: any = {
      ...data,
      updatedAt: new Date(),
    };

    // Convert ISO strings to Date objects if present
    if (data.appliedAt) {
      updateData.appliedAt = new Date(data.appliedAt);
    }
    if (data.nextFollowUpAt) {
      updateData.nextFollowUpAt = new Date(data.nextFollowUpAt);
    }

    const [updated] = await db
      .update(application)
      .set(updateData)
      .where(and(eq(application.id, id), eq(application.userId, userId)))
      .returning();

    return updated || null;
  }

  async delete(userId: string, id: string) {
    const [deleted] = await db
      .delete(application)
      .where(and(eq(application.id, id), eq(application.userId, userId)))
      .returning();

    return deleted !== undefined;
  }
}
