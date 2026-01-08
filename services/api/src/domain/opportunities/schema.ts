import { z } from "zod";

export const createOpportunitySchema = z.object({
  company: z.string().min(1).max(255),
  role: z.string().min(1).max(255),
  location: z.string().max(255).optional(),
  priority: z.enum(["A", "B", "C"]).default("B"),
  status: z.enum(["new", "validated", "ignored"]).default("validated"),
  url: z.string().optional(),
  source: z.string().max(255).optional(),
  notes: z.string().optional(),
});

export const updateStatusSchema = z.object({
  status: z.enum(["new", "validated", "ignored"]),
});

export type CreateOpportunityInput = z.infer<typeof createOpportunitySchema>;
export type UpdateStatusInput = z.infer<typeof updateStatusSchema>;
