import { pgTable, text, timestamp, varchar, index, pgEnum } from "drizzle-orm/pg-core";
import { relations } from "drizzle-orm";
import { user } from "../auth/schema";

export const priorityEnum = pgEnum("priority", ["A", "B", "C"]);

export const statusEnum = pgEnum("status", ["new", "validated","applied", "ignored"]);
export const opportunity = pgTable(
  "opportunity",
  {
    id: text("id").primaryKey().$defaultFn(() => crypto.randomUUID()),
    userId: text("user_id")
      .notNull()
      .references(() => user.id, { onDelete: "cascade" }),
    company: varchar("company", { length: 255 }).notNull(),
    role: varchar("role", { length: 255 }).notNull(),
    location: varchar("location", { length: 255 }),
    priority: priorityEnum("priority").notNull().default("B"),
    status: statusEnum("status").notNull().default("new"),
    url: text("url"),
    source: varchar("source", { length: 255 }),
    notes: text("notes"),
    createdAt: timestamp("created_at").defaultNow().notNull(),
    updatedAt: timestamp("updated_at")
      .defaultNow()
      .$onUpdate(() => new Date())
      .notNull(),
  },
  (table) => [
    index("opportunity_userId_idx").on(table.userId),
    index("opportunity_status_idx").on(table.status),
    index("opportunity_userId_status_idx").on(table.userId, table.status),
  ]
);

export const opportunityRelations = relations(opportunity, ({ one }) => ({
  user: one(user, {
    fields: [opportunity.userId],
    references: [user.id],
  }),
}));
