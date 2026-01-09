import { z } from "zod";

export const createUserPreferencesSchema = z.object({
  education: z.string().optional(),
  preferredDomains: z.array(z.string()).optional(),
  preferredContract: z.string().optional(),
  preferredLocation: z.string().optional(),
});

export const updateUserPreferencesSchema = z.object({
  education: z.string().optional(),
  preferredDomains: z.array(z.string()).optional(),
  preferredContract: z.string().optional(),
  preferredLocation: z.string().optional(),
});

export type CreateUserPreferencesInput = z.infer<typeof createUserPreferencesSchema>;
export type UpdateUserPreferencesInput = z.infer<typeof updateUserPreferencesSchema>;
