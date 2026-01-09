import { relations } from "drizzle-orm";
import { userSkill } from "./schema";
import { user } from "../auth/schema";

export const userSkillRelations = relations(userSkill, ({ one }) => ({
  user: one(user, {
    fields: [userSkill.userId],
    references: [user.id],
  }),
}));
