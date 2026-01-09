import { InferSelectModel, InferInsertModel } from "drizzle-orm";
import { userPreferences } from "./schema";

export type UserPreferences = InferSelectModel<typeof userPreferences>;
export type NewUserPreferences = InferInsertModel<typeof userPreferences>;
