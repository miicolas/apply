import { db } from "../../db/index.js";
import { opportunity, statusEnum } from "../../db/schema/opportunities/schema";
import { eq, and, desc, InferEnum} from "drizzle-orm";
import type { CreateOpportunityInput } from "./schema";

export class OpportunityService {
  async findAll(userId: string, status?: InferEnum<typeof statusEnum>) {
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

  async updateStatus(userId: string, id: string, status: InferEnum<typeof statusEnum>) {
    const [updated] = await db
      .update(opportunity)
      .set({
        status: status,
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
