import { pgTable, text, timestamp, index, pgEnum } from "drizzle-orm/pg-core";

export const jobStatusEnum = pgEnum("job_status", ["pending", "running", "completed", "failed", "cancelled"]);

export const job = pgTable("job", {
  id: text("id").primaryKey(),
  status: jobStatusEnum("status").default("pending"),
  triggerId: text("trigger_id").notNull(),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at")
    .defaultNow()
    .$onUpdate(() => /* @__PURE__ */ new Date())
    .notNull(),
}, (table) => [index("job_triggerId_idx").on(table.triggerId)]);