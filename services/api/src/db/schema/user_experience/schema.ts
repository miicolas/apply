import { pgTable, text, timestamp, varchar, date, index } from "drizzle-orm/pg-core";
import { user } from "../auth/schema";

export const userExperience = pgTable(
  "user_experience",
  {
    id: text("id")
      .primaryKey()
      .$defaultFn(() => crypto.randomUUID()),
    userId: text("user_id")
      .notNull()
      .references(() => user.id, { onDelete: "cascade" }),
    title: varchar("title", { length: 255 }).notNull(),
    company: varchar("company", { length: 255 }),
    description: text("description"),
    startDate: date("start_date"),
    endDate: date("end_date"), // null if current position
    createdAt: timestamp("created_at").defaultNow().notNull(),
    updatedAt: timestamp("updated_at")
      .defaultNow()
      .$onUpdate(() => new Date())
      .notNull(),
  },
  (table) => [
    index("user_experience_userId_idx").on(table.userId),
  ]
);
