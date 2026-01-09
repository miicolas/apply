import { relations } from "drizzle-orm";
import { application } from "./schema";
import { user } from "../auth/schema";
import { jobOffer } from "../job_offer/schema";

export const applicationRelations = relations(application, ({ one }) => ({
  user: one(user, {
    fields: [application.userId],
    references: [user.id],
  }),
  jobOffer: one(jobOffer, {
    fields: [application.jobOfferId],
    references: [jobOffer.id],
  }),
}));
