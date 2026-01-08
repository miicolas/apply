import { db } from "../../db/index.js";
import { opportunity } from "../../db/schema/opportunities/schema.js";
import { eq, and, desc } from "drizzle-orm";
import type { CreateOpportunityInput } from "./schema.js";

export class OpportunityService {
  async findAll(userId: string, status?: string) {
    const conditions = [eq(opportunity.userId, userId)];

    if (status) {
      conditions.push(eq(opportunity.status, status));
    }

    return await db
      .select()
      .from(opportunity)
      .where(and(...conditions))
      .orderBy(desc(opportunity.createdAt));
  }

  async findById(userId: string, id: string) {
    const [result] = await db
      .select()
      .from(opportunity)
      .where(and(eq(opportunity.id, id), eq(opportunity.userId, userId)));

    return result || null;
  }

  async create(userId: string, data: CreateOpportunityInput) {
    const [newOpportunity] = await db
      .insert(opportunity)
      .values({
        ...data,
        userId,
      })
      .returning();

    return newOpportunity;
  }

  async updateStatus(userId: string, id: string, status: string) {
    const [updated] = await db
      .update(opportunity)
      .set({
        status,
        updatedAt: new Date(),
      })
      .where(and(eq(opportunity.id, id), eq(opportunity.userId, userId)))
      .returning();

    return updated || null;
  }

  async delete(userId: string, id: string) {
    const [deleted] = await db
      .delete(opportunity)
      .where(and(eq(opportunity.id, id), eq(opportunity.userId, userId)))
      .returning();

    return deleted !== undefined;
  }
}
