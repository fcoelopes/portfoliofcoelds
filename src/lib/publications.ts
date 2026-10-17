import type { CollectionEntry } from "astro:content";

type Article = CollectionEntry<"blog">;

/** Every public channel (blog index and RSS) must expose the same articles. */
export const isListedArticle = (article: Article): boolean => !article.data.draft;

/** Align the feed URL with src/pages/blog/[...slug].astro. */
export const articleHref = (article: Article): string =>
  `/blog/${article.id.replace(/\.mdx?$/, "")}/`;
