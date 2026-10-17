import { getCollection } from "astro:content";
import rss from "@astrojs/rss";
import { articleHref, isListedArticle } from "../lib/publications";

/** @type {import("astro").APIRoute} */
export async function GET(context) {
  const posts = (await getCollection("blog"))
    .filter(isListedArticle)
    .sort((a, b) =>
      b.data.pubDate.valueOf() - a.data.pubDate.valueOf() ||
      a.data.title.localeCompare(b.data.title, "pt-BR"),
    );

  const feed = await rss({
    title: "Caderno de ideias | Edson Lopes",
    description:
      "Artigos sobre engenharia, confiabilidade, inteligência artificial, finanças, projetos e tomada de decisão.",
    site: context.site,
    customData: "<language>pt-BR</language>",
    items: posts.map((post) => ({
      title: post.data.title,
      description: post.data.description,
      pubDate: post.data.pubDate,
      link: articleHref(post),
    })),
  });

  // Present the RSS as a readable article list in browsers while preserving
  // standards-compliant XML for feed readers and aggregators.
  const xml = await feed.text();
  const stylesheet = '<?xml-stylesheet type="text/xsl" href="/rss.xsl"?>';
  const readableXml = xml.startsWith("<?xml ")
    ? xml.replace(/^(<\?xml[^>]*\?>)/, `$1\n${stylesheet}`)
    : `${stylesheet}\n${xml}`;

  return new Response(readableXml, {
    status: feed.status,
    headers: feed.headers,
  });
}
