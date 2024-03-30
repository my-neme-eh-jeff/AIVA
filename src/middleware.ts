import createMiddleware from "next-intl/middleware";
import { locales } from "i18n/i18n";

export default createMiddleware({
  locales: locales,
  // Used when no locale matches
  defaultLocale: "eng",
});

export const config = {
  matcher: ["/", `/(eng|hin)/:path*`],
};
