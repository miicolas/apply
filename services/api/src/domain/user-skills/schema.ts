import { z } from "zod";
import { NewUserSkill, UserSkill } from "@/src/db/schema";

export const createUserSkillSchema = z.object({
  name: z.string().min(1).max(255),
  level: z.enum(["beginner", "intermediate", "advanced"]).optional(),
});

export const updateUserSkillSchema = z.object({
  name: z.string().min(1).max(255).optional(),
  level: z.enum(["beginner", "intermediate", "advanced"]).optional(),
});

export type CreateUserSkillInput = z.infer<typeof createUserSkillSchema>;
export type UpdateUserSkillInput = z.infer<typeof updateUserSkillSchema>;