import { pgTable, text, timestamp, varchar, index } from "drizzle-orm/pg-core";
import { user } from "../auth/schema";

export const userPreferences = pgTable(
  "user_preferences",
  {
    id: text("id")
      .primaryKey()
      .$defaultFn(() => crypto.randomUUID()),
    userId: text("user_id")
      .notNull()
      .references(() => user.id, { onDelete: "cascade" })
      .unique(),
    education: text("education"),
    preferredDomains: text("preferred_domains").array(), // Array of strings
    preferredContract: varchar("preferred_contract", { length: 50 }),
    preferredLocation: varchar("preferred_location", { length: 255 }),
    createdAt: timestamp("created_at").defaultNow().notNull(),
    updatedAt: timestamp("updated_at")
      .defaultNow()
      .$onUpdate(() => new Date())
      .notNull(),
  },
  (table) => [
    index("user_preferences_userId_idx").on(table.userId),
  ]
);
