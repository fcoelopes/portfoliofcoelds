<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>
  <xsl:template match="/">
    <html lang="pt-BR">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title>RSS | Caderno de ideias — Edson Lopes</title>
        <style>
          :root { color-scheme: dark; font-family: system-ui, -apple-system, "Segoe UI", sans-serif; background: #0b1019; color: #f3f0eb; }
          * { box-sizing: border-box; }
          body { margin: 0; }
          main { max-width: 970px; margin: 0 auto; padding: 4rem 1.25rem 6rem; }
          .kicker { font-size: .76rem; font-weight: 800; letter-spacing: .15em; color: #f3bb70; }
          h1 { margin: 1.2rem 0; font-size: clamp(2.7rem, 7vw, 5.4rem); line-height: 1; letter-spacing: -.065em; }
          p { line-height: 1.7; color: #c3cedc; }
          .intro { max-width: 680px; font-size: 1.1rem; }
          code { color: #f3bd76; overflow-wrap: anywhere; }
          .feed { margin: 2rem 0 4rem; padding: 1.3rem 1.5rem; border: 1px solid #4f6075; border-radius: .8rem; background: #15202d; }
          .feed p { margin: .4rem 0; }
          .feed a { color: #f6bc6d; }
          ol { list-style: none; padding: 0; margin: 2rem 0; }
          li { border-top: 1px solid #364254; padding: 1.35rem 0; }
          li a { color: #f3f0eb; text-decoration: none; font-size: clamp(1.22rem, 2.8vw, 1.7rem); font-weight: 750; letter-spacing: -.02em; }
          li a:hover { color: #f6bc6d; }
          li p { max-width: 790px; margin: .55rem 0 0; }
          .date { display: block; color: #f2bc75; letter-spacing: .07em; font-weight: 750; font-size: .75rem; margin-bottom: .6rem; }
          footer { border-top: 1px solid #364254; padding-top: 2rem; }
          footer a { color: #f3bb70; }
          a:focus-visible { outline: 3px solid #f3bb70; outline-offset: 4px; }
        </style>
      </head>
      <body>
        <main>
          <p class="kicker">PUBLICAÇÃO PESSOAL / FEED RSS</p>
          <h1>Caderno de ideias.</h1>
          <p class="intro">Este é o feed RSS do blog. Ele permite receber automaticamente novos artigos no seu leitor de notícias preferido.</p>
          <section class="feed" aria-label="Como acompanhar">
            <strong>Como assinar o blog</strong>
            <p>Copie o endereço <code>https://fcoelds.dev.br/rss.xml</code> e adicione-o ao seu leitor RSS.</p>
            <p>Também é possível navegar pelos artigos abaixo.</p>
          </section>
          <h2>Últimas publicações</h2>
          <ol>
            <xsl:for-each select="rss/channel/item">
              <li>
                <span class="date"><xsl:value-of select="pubDate"/></span>
                <a href="{link}"><xsl:value-of select="title"/></a>
                <p><xsl:value-of select="description"/></p>
              </li>
            </xsl:for-each>
          </ol>
          <footer><a href="/blog/">← Voltar para o blog</a></footer>
        </main>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
