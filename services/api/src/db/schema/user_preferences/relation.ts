import { relations } from "drizzle-orm";
import { userPreferences } from "./schema";
import { user } from "../auth/schema";

export const userPreferencesRelations = relations(userPreferences, ({ one }) => ({
  user: one(user, {
    fields: [userPreferences.userId],
    references: [user.id],
  }),
}));
