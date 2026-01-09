import { z } from "zod";

export const applicationStatusSchema = z.enum([
  "to_apply",
  "applied",
  "follow_up",
  "interview",
  "offer",
  "rejected",
]);

export const createApplicationSchema = z.object({
  jobOfferId: z.string().uuid(),
  status: applicationStatusSchema.default("to_apply"),
  coverLetter: z.string().optional(),
  emailContent: z.string().optional(),
});

export const updateApplicationSchema = z.object({
  status: applicationStatusSchema.optional(),
  coverLetter: z.string().optional(),
  emailContent: z.string().optional(),
  appliedAt: z.string().datetime().optional(),
  nextFollowUpAt: z.string().datetime().optional(),
});

export type CreateApplicationInput = z.infer<typeof createApplicationSchema>;
export type UpdateApplicationInput = z.infer<typeof updateApplicationSchema>;
export type ApplicationStatus = z.infer<typeof applicationStatusSchema>;
