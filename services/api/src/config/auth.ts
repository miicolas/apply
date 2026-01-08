import "dotenv/config";
import { betterAuth } from "better-auth";
import { drizzleAdapter } from "better-auth/adapters/drizzle";
import { bearer } from "better-auth/plugins";
import { db } from "../db/index.js";

const defaultTrustedOrigins = [
    "apply://",
    "http://localhost:3000",
    "http://127.0.0.1:3000",
];

const baseURL = process.env.BETTER_AUTH_URL || "http://localhost:3000";
const trustedOrigins = process.env.BETTER_AUTH_TRUSTED_ORIGINS
    ? [
        ...defaultTrustedOrigins,
        ...process.env.BETTER_AUTH_TRUSTED_ORIGINS.split(",").map((origin) => origin.trim())
      ]
    : defaultTrustedOrigins;


export const auth = betterAuth({
    database: drizzleAdapter(db, {
        provider: "pg",
    }),
    secret: process.env.BETTER_AUTH_SECRET!,
    baseURL,
    trustedOrigins,
    
    advanced: {
        useSecureCookies: false,
        crossSubDomainCookies: {
            enabled: false,
        },
    },

    emailAndPassword: {
        enabled: true,
    },

    plugins: [
        bearer(),
    ],
});
