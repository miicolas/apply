import { relations } from "drizzle-orm";
import { skill } from "./schema";
import { user } from "../auth/schema";

export const skillRelations = relations(skill, ({ one }) => ({
  user: one(user, {
    fields: [skill.userId],
    references: [user.id],
  }),
}));