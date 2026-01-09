import { pgTable, text, timestamp, pgEnum, index } from "drizzle-orm/pg-core";
import { user } from "../auth/schema";
import { jobOffer } from "../job_offer/schema";

export const applicationStatusEnum = pgEnum("application_status", [
  "to_apply",
  "applied",
  "follow_up",
  "interview",
  "offer",
  "rejected",
]);

export const application = pgTable(
  "application",
  {
    id: text("id")
      .primaryKey()
      .$defaultFn(() => crypto.randomUUID()),
    userId: text("user_id")
      .notNull()
      .references(() => user.id, { onDelete: "cascade" }),
    jobOfferId: text("job_offer_id")
      .notNull()
      .references(() => jobOffer.id, { onDelete: "cascade" }),
    status: applicationStatusEnum("status").default("to_apply").notNull(),
    coverLetter: text("cover_letter"),
    emailContent: text("email_content"),
    appliedAt: timestamp("applied_at"),
    nextFollowUpAt: timestamp("next_follow_up_at"),
    createdAt: timestamp("created_at").defaultNow().notNull(),
    updatedAt: timestamp("updated_at")
      .defaultNow()
      .$onUpdate(() => new Date())
      .notNull(),
  },
  (table) => [
    index("application_userId_idx").on(table.userId),
    index("application_jobOfferId_idx").on(table.jobOfferId),
    index("application_status_idx").on(table.status),
    index("application_userId_status_idx").on(table.userId, table.status),
  ]
);
