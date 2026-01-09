import { InferSelectModel, InferInsertModel, InferEnum } from "drizzle-orm";
import { application, applicationStatusEnum } from "./schema";

export type Application = InferSelectModel<typeof application>;
export type NewApplication = InferInsertModel<typeof application>;
export type ApplicationStatus = InferEnum<typeof applicationStatusEnum>;
