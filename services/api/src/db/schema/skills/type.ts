import { InferSelectModel, InferInsertModel } from "drizzle-orm";
import { skill } from "./schema";

export type Skill = InferSelectModel<typeof skill>;
export type NewSkill = InferInsertModel<typeof skill>;