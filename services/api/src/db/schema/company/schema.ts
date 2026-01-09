import { pgTable, text, timestamp, varchar, index } from "drizzle-orm/pg-core";

export const company = pgTable("company", {
  id: text("id")
    .primaryKey()
    .$defaultFn(() => crypto.randomUUID()),
  name: text("name").notNull(),
  description: text("description"),
  website: varchar("website", { length: 500 }),
  logo: varchar("logo", { length: 500 }), // URL to logo
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at")
    .defaultNow()
    .$onUpdate(() => new Date())
    .notNull(),
}, (table) => [index("company_name_idx").on(table.name)]);