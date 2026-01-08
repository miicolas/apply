import "dotenv/config";
import { Resend } from "resend";
import { render } from "@react-email/render";
import React from "react";
import { OtpEmail, getOtpEmailSubject } from "../emails/index";

const resend = new Resend(process.env.RESEND_API_KEY);

const fromEmail = process.env.RESEND_FROM_EMAIL || "noreply@example.com";

export async function sendOTPEmail({
    email,
    otp,
    type,
}: {
    email: string;
    otp: string;
    type: "sign-in" | "email-verification" | "forget-password";
}) {
    try {
        const html = await render(React.createElement(OtpEmail, { otp, type }));
        const subject = getOtpEmailSubject(type);

        // Don't await to avoid timing attacks
        resend.emails.send({
            from: fromEmail,
            to: [email],
            subject,
            html,
        });

        return { success: true };
    } catch (error) {
        console.error("Error sending OTP email:", error);
        throw error;
    }
}
