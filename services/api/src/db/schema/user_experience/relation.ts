import { relations } from "drizzle-orm";
import { userExperience } from "./schema";
import { user } from "../auth/schema";

export const userExperienceRelations = relations(userExperience, ({ one }) => ({
  user: one(user, {
    fields: [userExperience.userId],
    references: [user.id],
  }),
}));
