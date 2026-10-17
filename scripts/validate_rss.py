"""Validate the compiled RSS feed and its agreement with the public blog.

Run after npm run build. Python stdlib only; no extra npm packages required.
"""

from __future__ import annotations

import re
from pathlib import Path
from urllib.parse import urlsplit
from xml.etree import ElementTree

ROOT = Path(__file__).resolve().parents[1]
DIST = ROOT / "dist"
SITE = "fcoelds.dev.br"


def validate() -> None:
    feed_file = DIST / "rss.xml"
    blog_file = DIST / "blog" / "index.html"
    xsl_file = DIST / "rss.xsl"

    for path in (feed_file, blog_file, xsl_file):
        if not path.is_file():
            raise AssertionError(f"Missing build artifact: {path}")

    xml = feed_file.read_text(encoding="utf-8")
    if '<?xml-stylesheet type="text/xsl" href="/rss.xsl"?>' not in xml:
        raise AssertionError("RSS stylesheet PI was not included")

    rss = ElementTree.fromstring(xml)
    if rss.tag != "rss":
        raise AssertionError("RSS document is not rooted at <rss>")

    channel = rss.find("channel")
    if channel is None:
        raise AssertionError("Missing <channel> in RSS")
    if not channel.findtext("title") or not channel.findtext("description"):
        raise AssertionError("RSS channel needs a title and description")

    items = channel.findall("item")
    if not items:
        raise AssertionError("RSS feed has no published items")

    feed_paths: set[str] = set()
    for item in items:
        for field in ("title", "description", "pubDate", "link"):
            if not item.findtext(field):
                raise AssertionError(f"Missing {field} in RSS item")

        link = item.findtext("link")
        assert link is not None
        parsed = urlsplit(link)
        if parsed.scheme != "https" or parsed.netloc != SITE:
            raise AssertionError(f"Unexpected RSS link host: {link}")
        if not re.fullmatch(r"/blog/[^?#]+/", parsed.path):
            raise AssertionError(f"Malformed RSS article URL: {link}")
        if parsed.path.endswith((".md/", ".mdx/")):
            raise AssertionError(f"RSS links to a source file: {link}")

        target = DIST / parsed.path.lstrip("/") / "index.html"
        if not target.is_file():
            raise AssertionError(f"RSS item points to missing built article: {target}")
        if parsed.path in feed_paths:
            raise AssertionError(f"Duplicate RSS link: {link}")
        feed_paths.add(parsed.path)

    # Blog index is the authoritative list of public articles. Avoid diverging
    # publish/draft visibility between the HTML archive and the RSS channel.
    html = blog_file.read_text(encoding="utf-8")
    html_paths = set(re.findall(r'href="(/blog/[^"]+/)"', html))
    if feed_paths != html_paths:
        raise AssertionError(
            f"Feed/blog mismatch. Only in RSS: {sorted(feed_paths - html_paths)}; "
            f"only in blog: {sorted(html_paths - feed_paths)}"
        )

    print(f"RSS is valid XML. {len(items)} items, all links resolve; RSS and blog agree.")


if __name__ == "__main__":
    validate()
