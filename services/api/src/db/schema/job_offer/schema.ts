import { pgTable, text, timestamp, varchar, boolean, index, pgEnum, integer, date } from "drizzle-orm/pg-core";
import { company } from "../company/schema";
import { user } from "../auth/schema";

export const contractTypeEnum = pgEnum("contract_type", [
  "cdi",
  "cdd",
  "alternance",
  "stage",
  "freelance",
  "interim",
]);

export const remotePolicyEnum = pgEnum("remote_policy", ["none", "partial", "full"]);

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
    requiredSkills: text("required_skills").array(),
    contractType: contractTypeEnum("contract_type"),
    location: varchar("location", { length: 255 }),
    salaryMin: integer("salary_min"),           // €/mois
    salaryMax: integer("salary_max"),           // €/mois
    duration: varchar("duration", { length: 100 }),
    remotePolicy: remotePolicyEnum("remote_policy"),
    startDate: date("start_date"),
    experienceYears: integer("experience_years"),
    educationLevel: varchar("education_level", { length: 100 }),
    isPublic: boolean("is_public").default(false).notNull(),
    isActive: boolean("is_active").default(true).notNull(),
    createdByUserId: text("created_by_user_id")
      .notNull()
      .references(() => user.id, { onDelete: "cascade" }),
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
    index("job_offer_sourceUrl_idx").on(table.sourceUrl),
  ]
);
