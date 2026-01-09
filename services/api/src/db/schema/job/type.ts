import { InferSelectModel, InferInsertModel, InferEnum } from "drizzle-orm";
import { job, jobStatusEnum } from "./schema";

export type Job = InferSelectModel<typeof job>;
export type NewJob = InferInsertModel<typeof job>;

export type JobStatus = InferEnum<typeof jobStatusEnum>;