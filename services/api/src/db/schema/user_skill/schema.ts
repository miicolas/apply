import { pgTable, text, timestamp, varchar, index } from "drizzle-orm/pg-core";
import { user } from "../auth/schema";

export const userSkill = pgTable(
  "user_skill",
  {
    id: text("id")
      .primaryKey()
      .$defaultFn(() => crypto.randomUUID()),
    userId: text("user_id")
      .notNull()
      .references(() => user.id, { onDelete: "cascade" }),
    name: varchar("name", { length: 255 }).notNull(),
    level: varchar("level", { length: 50 }), // e.g., "beginner", "intermediate", "advanced"
    createdAt: timestamp("created_at").defaultNow().notNull(),
    updatedAt: timestamp("updated_at")
      .defaultNow()
      .$onUpdate(() => new Date())
      .notNull(),
  },
  (table) => [
    index("user_skill_userId_idx").on(table.userId),
  ]
);
