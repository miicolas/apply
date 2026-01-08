import "dotenv/config";
import { betterAuth } from "better-auth";
import { drizzleAdapter } from "better-auth/adapters/drizzle";
import { bearer } from "better-auth/plugins";
import { db } from "../db/index.js";

// Default trusted origins including iOS app scheme
const defaultTrustedOrigins = [
    "apply://",  // iOS app custom scheme
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

console.log(`🔧 [Auth Config] Initialisation Better Auth`);
console.log(`🔧 [Auth Config] Base URL: ${baseURL}`);
console.log(`🔧 [Auth Config] Trusted Origins:`, trustedOrigins);

export const auth = betterAuth({
    database: drizzleAdapter(db, {
        provider: "pg",
    }),
    secret: process.env.BETTER_AUTH_SECRET!,
    baseURL,
    trustedOrigins,
    
    // Allow requests without Origin header (for native mobile apps)
    advanced: {
        useSecureCookies: false, // Set to true in production with HTTPS
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

console.log(`✅ [Auth Config] Better Auth initialisé`);
