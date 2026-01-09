import { z } from "zod";

export const createJobOfferSchema = z.object({
  sourceUrl: z.string().url(),
  title: z.string().min(1),
  companyId: z.string().uuid(),
  category: z.string().optional(),
  description: z.string().optional(),
  requiredSkills: z.array(z.string()).optional(),
});

export const updateJobOfferSchema = z.object({
  title: z.string().min(1).optional(),
  category: z.string().optional(),
  description: z.string().optional(),
  requiredSkills: z.array(z.string()).optional(),
  isPublic: z.boolean().optional(),
  isActive: z.boolean().optional(),
});

export type CreateJobOfferInput = z.infer<typeof createJobOfferSchema>;
export type UpdateJobOfferInput = z.infer<typeof updateJobOfferSchema>;
