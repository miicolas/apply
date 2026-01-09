import { company } from "./schema";
import { InferSelectModel, InferInsertModel } from "drizzle-orm";

export type Company = InferSelectModel<typeof company>;
export type NewCompany = InferInsertModel<typeof company>;