import { type Config } from "drizzle-kit";

import { env } from "@/env";
import { siteConfig } from "siteConfig";

export default {
  schema: "./src/server/db/schema.ts",
  driver: "pg",
  dbCredentials: {
    connectionString: env.DATABASE_URL,
  },
  tablesFilter: [`${siteConfig.name}_*`],
  out: "./dbMigrations",
} satisfies Config;
