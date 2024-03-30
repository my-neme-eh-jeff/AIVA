import "@/app/globals.css";
import type { Metadata } from "next";

import AuthSessionProvider from "@/Hooks/Providers/AuthSessionProvider";
import { UIProvider } from "@/Hooks/Providers/NextUIProvider";
import { TRPCReactProvider } from "@/server/trpc/react";
import { cn } from "@/utils/ui";
import { GeistSans } from "geist/font/sans";
import type { Author } from "next/dist/lib/metadata/types/metadata-types";
import { siteConfig } from "siteConfig";
import { NextIntlClientProvider, useMessages } from "next-intl";

export const metadata: Metadata = {
  metadataBase: new URL(siteConfig.url),
  title: {
    default: siteConfig.name,
    template: `%s | ${siteConfig.name}`,
  },
  creator: siteConfig.creator,
  icons: [{ rel: "icon", url: "/favicon.ico" }],
  keywords: [],
  description: siteConfig.description,
  authors: siteConfig.authors as Author,
  openGraph: {
    type: "website",
    locale: "en_IN",
    url: siteConfig.url,
    title: siteConfig.name,
    description: siteConfig.description,
    siteName: siteConfig.name,
  },
  twitter: {
    creatorId: "@NambisanAman",
    card: "summary_large_image",
    title: siteConfig.name,
    creator: "@NambisanAman",
    images: [`${siteConfig.url}/og.webp`],
    description: siteConfig.description,
  },
};

export default function RootLayout({
  children,
  params: { locale },
}: {
  children: React.ReactNode;
  params: { locale: string };
}) {
  const messages = useMessages();

  return (
    <html
      lang={locale}
      className={cn(GeistSans.className, "scroll-smooth")}
      suppressHydrationWarning
    >
      <body suppressHydrationWarning>
        <TRPCReactProvider>
          <AuthSessionProvider>
            <UIProvider
              themeProps={{
                attribute: "class",
                defaultTheme: "system",
                children,
              }}
            >
              <NextIntlClientProvider locale={locale} messages={messages}>
                {children}
              </NextIntlClientProvider>
            </UIProvider>
          </AuthSessionProvider>
        </TRPCReactProvider>
      </body>
    </html>
  );
}
