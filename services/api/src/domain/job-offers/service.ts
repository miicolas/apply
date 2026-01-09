import { db } from "../../db/index.js";
import { jobOffer, type NewJobOffer } from "../../db/schema/job_offer/index.js";
import { eq, and, desc, gte, sql } from "drizzle-orm";
import type { CreateJobOfferInput, UpdateJobOfferInput } from "./schema.js";

export class JobOfferService {
  async findAll(userId?: string, filters?: { isPublic?: boolean; isActive?: boolean; recentOnly?: boolean }) {
    const conditions = [];

    if (userId) {
      conditions.push(eq(jobOffer.createdByUserId, userId));
    }

    if (filters?.isPublic !== undefined) {
      conditions.push(eq(jobOffer.isPublic, filters.isPublic));
    }

    if (filters?.isActive !== undefined) {
      conditions.push(eq(jobOffer.isActive, filters.isActive));
    }

    if (filters?.recentOnly) {
      // Only offers created in the last 15 days
      const fifteenDaysAgo = new Date();
      fifteenDaysAgo.setDate(fifteenDaysAgo.getDate() - 15);
      conditions.push(gte(jobOffer.createdAt, fifteenDaysAgo));
    }

    const query = db
      .select()
      .from(jobOffer)
      .where(conditions.length > 0 ? and(...conditions) : undefined)
      .orderBy(desc(jobOffer.createdAt));

    return await query;
  }

  async findById(id: string) {
    const [result] = await db
      .select()
      .from(jobOffer)
      .where(eq(jobOffer.id, id));

    return result || null;
  }

  async findBySourceUrl(sourceUrl: string) {
    const [result] = await db
      .select()
      .from(jobOffer)
      .where(eq(jobOffer.sourceUrl, sourceUrl));

    return result || null;
  }

  async create(userId: string, data: CreateJobOfferInput) {
    // Set publicAt to 48 hours from now
    const publicAt = new Date();
    publicAt.setHours(publicAt.getHours() + 48);

    const [newJobOffer] = await db
      .insert(jobOffer)
      .values({
        ...data,
        createdByUserId: userId,
        isPublic: false, // Private for 48h
        isActive: true,
        publicAt,
      })
      .returning();

    return newJobOffer;
  }

  async update(id: string, data: UpdateJobOfferInput) {
    const [updated] = await db
      .update(jobOffer)
      .set({
        ...data,
        updatedAt: new Date(),
      })
      .where(eq(jobOffer.id, id))
      .returning();

    return updated || null;
  }

  async delete(id: string) {
    const [deleted] = await db
      .delete(jobOffer)
      .where(eq(jobOffer.id, id))
      .returning();

    return deleted !== undefined;
  }

  async makePublic(id: string) {
    const [updated] = await db
      .update(jobOffer)
      .set({
        isPublic: true,
        publicAt: new Date(),
        updatedAt: new Date(),
      })
      .where(eq(jobOffer.id, id))
      .returning();

    return updated || null;
  }
}
