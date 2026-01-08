import {
    Html,
    Head,
    Body,
    Container,
    Section,
    Text,
    Heading,
} from "@react-email/components";
import { OtpDisplay } from "./OtpDisplay";

interface OtpEmailProps {
    otp: string;
    type: "sign-in" | "email-verification" | "forget-password";
}

const getSubject = (type: OtpEmailProps["type"]): string => {
    switch (type) {
        case "sign-in":
            return "Your sign-in code";
        case "email-verification":
            return "Verify your email address";
        case "forget-password":
            return "Reset your password";
        default:
            return "Your verification code";
    }
};

const getTitle = (type: OtpEmailProps["type"]): string => {
    switch (type) {
        case "sign-in":
            return "Sign in to your account";
        case "email-verification":
            return "Verify your email address";
        case "forget-password":
            return "Reset your password";
        default:
            return "Verification code";
    }
};

const getDescription = (type: OtpEmailProps["type"]): string => {
    switch (type) {
        case "sign-in":
            return "Use the code below to sign in to your account. This code will expire in 5 minutes.";
        case "email-verification":
            return "Use the code below to verify your email address. This code will expire in 5 minutes.";
        case "forget-password":
            return "Use the code below to reset your password. This code will expire in 5 minutes.";
        default:
            return "Use the code below to complete your request. This code will expire in 5 minutes.";
    }
};

export function OtpEmail({ otp, type }: OtpEmailProps) {
    return (
        <Html>
            <Head />
            <Body style={main}>
                <Container style={container}>
                    <Section style={section}>
                        <Heading style={h1}>{getTitle(type)}</Heading>
                        <Text style={text}>{getDescription(type)}</Text>
                        <OtpDisplay otp={otp} />
                        <Text style={footer}>
                            If you didn't request this code, you can safely ignore this email.
                        </Text>
                    </Section>
                </Container>
            </Body>
        </Html>
    );
}

export const getOtpEmailSubject = (type: OtpEmailProps["type"]): string => {
    return getSubject(type);
};

const main = {
    backgroundColor: "#f6f9fc",
    fontFamily:
        '-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Ubuntu,sans-serif',
};

const container = {
    backgroundColor: "#ffffff",
    margin: "0 auto",
    padding: "20px 0 48px",
    marginBottom: "64px",
};

const section = {
    padding: "0 48px",
};

const h1 = {
    color: "#333",
    fontSize: "24px",
    fontWeight: "600",
    lineHeight: "40px",
    margin: "0 0 20px",
};

const text = {
    color: "#666",
    fontSize: "16px",
    lineHeight: "26px",
    margin: "0 0 30px",
};

const footer = {
    color: "#999",
    fontSize: "14px",
    lineHeight: "24px",
    marginTop: "30px",
};
