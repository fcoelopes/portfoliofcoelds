import { defineCollection } from "astro:content";
import { glob } from "astro/loaders";
import { z } from "astro/zod";

const blog = defineCollection({
  loader: glob({ base: "./src/content/blog", pattern: "**/*.{md,mdx}" }),

  schema: ({ image }) =>
    z.object({
      title: z.string(),
      description: z.string(),

      pubDate: z.coerce.date(),
      updatedDate: z.coerce.date().optional(),

      heroImage: image().optional(),
      heroImageAlt: z.string().optional(),

      tags: z.array(z.string()).optional(),
      readingTime: z.string().optional(),

      type: z.enum(["note", "project"]).default("note"),

      category: z.string().optional(),
      status: z.string().optional(),
      progress: z.number().min(0).max(100).optional(),

      problem: z.string().optional(),
      application: z.string().optional(),
      method: z.string().optional(),
      value: z.string().optional(),
      stack: z.array(z.string()).optional(),
    }),
});

export const collections = { blog };