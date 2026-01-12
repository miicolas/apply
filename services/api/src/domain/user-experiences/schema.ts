import { z } from "zod";

export const createUserExperienceSchema = z.object({
  title: z.string().min(1),
  company: z.string().optional(),
  description: z.string().optional(),
  startDate: z.string().optional(), // ISO date string
  endDate: z.string().optional(), // ISO date string
});

export const updateUserExperienceSchema = z.object({
  title: z.string().min(1),
  company: z.string().optional(),
  description: z.string().optional(),
  startDate: z.string().optional(),
  endDate: z.string().optional(),
});

export type CreateUserExperienceInput = z.infer<typeof createUserExperienceSchema>;
export type UpdateUserExperienceInput = z.infer<typeof updateUserExperienceSchema>;
