import { InferSelectModel, InferInsertModel } from "drizzle-orm";
import { jobOffer } from "./schema";

export type JobOffer = InferSelectModel<typeof jobOffer>;
export type NewJobOffer = InferInsertModel<typeof jobOffer>;
