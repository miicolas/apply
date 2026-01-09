import { InferSelectModel, InferInsertModel } from "drizzle-orm";
import { userExperience } from "./schema";

export type UserExperience = InferSelectModel<typeof userExperience>;
export type NewUserExperience = InferInsertModel<typeof userExperience>;
