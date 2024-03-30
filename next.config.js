await import("./src/env.js");

import createNextIntlPlugin from "next-intl/plugin";
const withNextIntl = createNextIntlPlugin("./i18n/i18n.ts");

/** @type {import("next").NextConfig} */
const config = {
  images: {
    domains: ["lh3.googleusercontent.com"],
  },
  logging: {
    fetches: {
      fullUrl: true,
    },
  },
  
};

export default withNextIntl(config);
