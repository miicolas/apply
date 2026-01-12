import { pgTable, text, timestamp, varchar, index, pgEnum } from "drizzle-orm/pg-core";
import { user } from "../auth/schema";

export const skillLevelEnum = pgEnum("skill_level", ["beginner", "intermediate", "advanced"]);
export const skill = pgTable(
  "skill",
  {
    id: text("id")
      .primaryKey()
      .$defaultFn(() => crypto.randomUUID()),
    name: varchar("name", { length: 255 }).notNull(),
    userId: text("user_id")
      .notNull()
      .references(() => user.id, { onDelete: "cascade" }),
    level: skillLevelEnum("level").default("beginner").notNull(),
    createdAt: timestamp("created_at").defaultNow().notNull(),
    updatedAt: timestamp("updated_at")
      .defaultNow()
      .$onUpdate(() => new Date())
      .notNull(),
  }
);