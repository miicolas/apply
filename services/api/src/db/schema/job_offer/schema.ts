import { pgTable, text, timestamp, varchar, boolean, index, pgEnum } from "drizzle-orm/pg-core";
import { company } from "../company/schema";
import { user } from "../auth/schema";

export const jobOffer = pgTable(
  "job_offer",
  {
    id: text("id")
      .primaryKey()
      .$defaultFn(() => crypto.randomUUID()),
    sourceUrl: text("source_url").notNull(),
    title: varchar("title", { length: 255 }).notNull(),
    companyId: text("company_id")
      .notNull()
      .references(() => company.id, { onDelete: "cascade" }),
    category: varchar("category", { length: 100 }), // e.g., "dev", "marketing", "data"
    description: text("description"),
    requiredSkills: text("required_skills").array(), // Array of strings
    isPublic: boolean("is_public").default(false).notNull(),
    isActive: boolean("is_active").default(true).notNull(),
    createdByUserId: text("created_by_user_id")
      .notNull()
      .references(() => user.id, { onDelete: "cascade" }),
    publicAt: timestamp("public_at"), // When the offer becomes public (48h after creation)
    createdAt: timestamp("created_at").defaultNow().notNull(),
    updatedAt: timestamp("updated_at")
      .defaultNow()
      .$onUpdate(() => new Date())
      .notNull(),
  },
  (table) => [
    index("job_offer_companyId_idx").on(table.companyId),
    index("job_offer_createdByUserId_idx").on(table.createdByUserId),
    index("job_offer_isPublic_idx").on(table.isPublic),
    index("job_offer_isActive_idx").on(table.isActive),
    index("job_offer_publicAt_idx").on(table.publicAt),
    index("job_offer_sourceUrl_idx").on(table.sourceUrl),
  ]
);
