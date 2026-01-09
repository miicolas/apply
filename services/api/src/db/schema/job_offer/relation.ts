import { relations } from "drizzle-orm";
import { jobOffer } from "./schema";
import { company } from "../company/schema";
import { user } from "../auth/schema";
import { application } from "../application/schema";

export const jobOfferRelations = relations(jobOffer, ({ one, many }) => ({
  company: one(company, {
    fields: [jobOffer.companyId],
    references: [company.id],
  }),
  createdByUser: one(user, {
    fields: [jobOffer.createdByUserId],
    references: [user.id],
  }),
  applications: many(application),
}));
