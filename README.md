# fcoelds.dev.br

Portfólio técnico de Edson Lopes, construído com Astro.

## Stack

- Astro 6
- TypeScript
- Markdown/MDX
- KaTeX
- Cloudflare Pages

## Desenvolvimento local

```bash
npm ci
npm run dev
```

Build de produção:

```bash
npm run check
npm run build
```

O site estático é gerado em `dist/`.

## Deploy

O deploy de produção é feito pelo **Cloudflare Pages**, conectado diretamente ao
repositório GitHub `fcoelopes/portfoliofcoelds`.

Fluxo esperado:

```text
push/merge em main
        ↓
Cloudflare Pages detecta o novo commit
        ↓
npm ci
npm run build
        ↓
publica dist/
        ↓
https://fcoelds.dev.br
```

Configuração do projeto no Cloudflare Pages:

- Production branch: `main`
- Build command: `npm run build`
- Build output directory: `dist`
- Node.js: `22.12.0` ou superior compatível com `package.json`

O workflow GitHub Actions em `.github/workflows/ci.yml` **não faz deploy**.
Ele apenas valida PRs e commits em `main` com `npm run check` e
`npm run build`. O Cloudflare Pages é a única origem de deploy do site.

## Estrutura principal

```text
src/
  components/
  content/blog/
  layouts/
  pages/
  styles/
public/
astro.config.mjs
```

## Conteúdo

Os projetos e notas técnicas ficam em `src/content/blog/`.
A página de projetos fica em `src/pages/projetos.astro`.
