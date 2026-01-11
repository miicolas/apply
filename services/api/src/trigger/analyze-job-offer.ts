import { task, metadata, logger } from "@trigger.dev/sdk/v3";
import { generateText } from "ai";
import { openai } from "@ai-sdk/openai";
import { db } from "../db/index";
import { company } from "../db/schema/company/schema";
import { jobOffer } from "../db/schema/job_offer/schema";
import { eq, ilike } from "drizzle-orm";
import { z } from "zod";

interface AnalyzeJobOfferPayload {
  url: string;
  userId: string;
}

interface ExtractedJobOffer {
  title: string;
  companyName: string;
  companyWebsite: string | null;
  companyDescription: string | null;
  description: string;
  category: string;
  requiredSkills: string[];
  location: string | null;
  contractType: string | null;
  salaryMin: number | null;
  salaryMax: number | null;
  duration: string | null;
  remotePolicy: string | null;
  startDate: string | null;
  experienceYears: number | null;
  educationLevel: string | null;
}

export const analyzeJobOfferTask = task({
  id: "analyze-job-offer",
  maxDuration: 300,
  retry: {
    maxAttempts: 3,
  },
  run: async (payload: AnalyzeJobOfferPayload) => {
    const { url, userId } = payload;

    // Step 1: Initialize
    metadata.set("progress", 0);
    metadata.set("status", "initializing");
    metadata.set("step", "Initialisation...");
    logger.info("Starting job offer analysis", { url, userId });

    // Step 2: Check for duplicates
    metadata.set("progress", 10);
    metadata.set("step", "Vérification des doublons...");

    const existingOffer = await db
      .select()
      .from(jobOffer)
      .where(eq(jobOffer.sourceUrl, url))
      .limit(1);

    if (existingOffer.length > 0) {
      metadata.set("progress", 100);
      metadata.set("status", "completed");
      metadata.set("step", "Offre existante trouvée");

      return {
        status: "existing",
        jobOfferId: existingOffer[0].id,
        message: "Cette offre existe déjà",
      };
    }

    // Step 3: Analyze with AI SDK
    metadata.set("progress", 20);
    metadata.set("status", "analyzing");
    metadata.set("step", "Analyse de l'offre avec IA...");
    logger.info("Analyzing job offer with AI", { url });

    const jobOfferSchema = z.object({
      title: z.string(),
      companyName: z.string(),
      companyWebsite: z.string().nullable(),
      companyDescription: z.string().nullable(),
      description: z.string(),
      category: z.string(),
      requiredSkills: z.array(z.string()),
      location: z.string().nullable(),
      contractType: z.string().nullable(),
      salaryMin: z.number().nullable(),
      salaryMax: z.number().nullable(),
      duration: z.string().nullable(),
      remotePolicy: z.string().nullable(),
      startDate: z.string().nullable(),
      experienceYears: z.number().nullable(),
      educationLevel: z.string().nullable(),
    });

    // Fetch the job page content first
    metadata.set("step", "Récupération de la page...");
    let pageContent = "";
    try {
      const response = await fetch(url, {
        headers: {
          "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36",
        },
      });
      const html = await response.text();
      // Extract text content (simple HTML stripping)
      pageContent = html
        .replace(/<script[^>]*>[\s\S]*?<\/script>/gi, "")
        .replace(/<style[^>]*>[\s\S]*?<\/style>/gi, "")
        .replace(/<[^>]+>/g, " ")
        .replace(/\s+/g, " ")
        .trim()
        .slice(0, 15000); // Limit content size
    } catch (fetchError) {
      logger.warn("Failed to fetch page directly, will rely on AI", { fetchError });
    }

    metadata.set("progress", 30);
    metadata.set("step", "Analyse avec IA...");

    const analysisPrompt = `Tu es un expert en analyse d'offres d'emploi. Analyse cette offre et extrait les informations clés.

URL de l'offre: ${url}

${pageContent ? `Contenu de la page:\n${pageContent}` : "Utilise tes connaissances pour analyser cette URL."}

Extrais:
1. Le titre du poste
2. Le nom de l'entreprise
3. Le site web de l'entreprise (si disponible)
4. Une brève description de l'entreprise (1-2 phrases max)
5. La description du poste : CONCISE (3-5 phrases max). Résume les missions principales, pas de copier-coller. Ne répète PAS les infos extraites ailleurs (salaire, lieu, etc.)
6. La catégorie parmi: dev, marketing, data, product, design, business, other
7. Les compétences requises sous forme de LABELS COURTS (ex: ["React", "TypeScript", "Node.js"] - jamais de phrases)
8. La localisation (ville uniquement, ex: "Paris", "Lyon")
9. Le type de contrat parmi: cdi, cdd, alternance, stage, freelance, interim
10. Le salaire minimum en €/mois (convertis si annuel: divise par 12)
11. Le salaire maximum en €/mois
12. La durée du contrat (ex: "5-6 mois", "12 mois") - pour CDD/stage/interim uniquement
13. La politique télétravail parmi: none (sur site), partial (hybride), full (100% remote)
14. La date de début souhaitée au format ISO (ex: "2026-02-09")
15. Les années d'expérience requises (nombre entier, ex: 5 pour "> 5 ans")
16. Le niveau d'éducation requis (ex: "Bac +5", "Master", "Bac +3")

Réponds UNIQUEMENT en JSON valide:
{
  "title": "string",
  "companyName": "string",
  "companyWebsite": "string | null",
  "companyDescription": "string | null",
  "description": "string (3-5 phrases max, missions principales)",
  "category": "dev | marketing | data | product | design | business | other",
  "requiredSkills": ["skill1", "skill2", ...],
  "location": "string | null",
  "contractType": "cdi | cdd | alternance | stage | freelance | interim | null",
  "salaryMin": number | null,
  "salaryMax": number | null,
  "duration": "string | null",
  "remotePolicy": "none | partial | full | null",
  "startDate": "YYYY-MM-DD | null",
  "experienceYears": number | null,
  "educationLevel": "string | null"
}`;

    const result = await generateText({
      model: openai("gpt-5-mini"),
      prompt: analysisPrompt,
    });

    // Step 4: Parse and validate AI response
    metadata.set("progress", 50);
    metadata.set("step", "Traitement des résultats...");

    let extractedData: ExtractedJobOffer;
    try {
      const jsonMatch = result.text.match(/\{[\s\S]*\}/);
      if (!jsonMatch) {
        throw new Error("No JSON found in response");
      }
      const parsed = JSON.parse(jsonMatch[0]);
      extractedData = jobOfferSchema.parse(parsed);
    } catch (error) {
      logger.error("Failed to parse AI response", { error, response: result.text });
      throw new Error("Impossible d'extraire les informations de l'offre");
    }

    // Step 5: Find or create company
    metadata.set("progress", 70);
    metadata.set("step", "Création de l'entreprise...");
    logger.info("Finding/creating company", { companyName: extractedData.companyName });

    let companyRecord = await db
      .select()
      .from(company)
      .where(ilike(company.name, extractedData.companyName))
      .limit(1);

    let companyId: string;
    if (companyRecord.length === 0) {
      const [newCompany] = await db
        .insert(company)
        .values({
          name: extractedData.companyName,
          website: extractedData.companyWebsite,
          description: extractedData.companyDescription,
        })
        .returning();
      companyId = newCompany.id;
      logger.info("Created new company", { companyId, name: extractedData.companyName });
    } else {
      companyId = companyRecord[0].id;
      logger.info("Found existing company", { companyId, name: extractedData.companyName });
    }

    // Step 6: Create job offer
    metadata.set("progress", 85);
    metadata.set("step", "Création de l'offre...");
    logger.info("Creating job offer", { title: extractedData.title });

    const publicAt = new Date();
    publicAt.setHours(publicAt.getHours() + 48);

    // Validate contractType against enum values
    const validContractTypes = ["cdi", "cdd", "alternance", "stage", "freelance", "interim"] as const;
    const contractType = extractedData.contractType?.toLowerCase();
    const validatedContractType = contractType && validContractTypes.includes(contractType as typeof validContractTypes[number])
      ? (contractType as typeof validContractTypes[number])
      : null;

    // Validate remotePolicy against enum values
    const validRemotePolicies = ["none", "partial", "full"] as const;
    const remotePolicy = extractedData.remotePolicy?.toLowerCase();
    const validatedRemotePolicy = remotePolicy && validRemotePolicies.includes(remotePolicy as typeof validRemotePolicies[number])
      ? (remotePolicy as typeof validRemotePolicies[number])
      : null;

    const [newJobOffer] = await db
      .insert(jobOffer)
      .values({
        sourceUrl: url,
        title: extractedData.title,
        companyId,
        category: extractedData.category,
        description: extractedData.description,
        requiredSkills: extractedData.requiredSkills,
        contractType: validatedContractType,
        location: extractedData.location,
        salaryMin: extractedData.salaryMin,
        salaryMax: extractedData.salaryMax,
        duration: extractedData.duration,
        remotePolicy: validatedRemotePolicy,
        startDate: extractedData.startDate,
        experienceYears: extractedData.experienceYears,
        educationLevel: extractedData.educationLevel,
        isPublic: false,
        isActive: true,
        createdByUserId: userId,
        publicAt,
      })
      .returning();

    // Step 7: Complete
    metadata.set("progress", 100);
    metadata.set("status", "completed");
    metadata.set("step", "Analyse terminée!");
    logger.info("Job offer analysis completed", { jobOfferId: newJobOffer.id });

    return {
      status: "created",
      jobOfferId: newJobOffer.id,
      jobOffer: {
        id: newJobOffer.id,
        title: newJobOffer.title,
        companyId,
        companyName: extractedData.companyName,
        category: newJobOffer.category,
        description: extractedData.description,
        requiredSkills: extractedData.requiredSkills,
        location: extractedData.location,
        contractType: extractedData.contractType,
        salaryMin: extractedData.salaryMin,
        salaryMax: extractedData.salaryMax,
        duration: extractedData.duration,
        remotePolicy: extractedData.remotePolicy,
        startDate: extractedData.startDate,
        experienceYears: extractedData.experienceYears,
        educationLevel: extractedData.educationLevel,
      },
    };
  },
});
