import { InferSelectModel, InferInsertModel } from "drizzle-orm";
import { userSkill } from "./schema";

export type UserSkill = InferSelectModel<typeof userSkill>;
export type NewUserSkill = InferInsertModel<typeof userSkill>;
