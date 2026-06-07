---
name: astro-personal-site
description: Contexto e convenções do site pessoal fcoelds.dev.br construído com Astro v6.4.4. Use esta skill sempre que for ler, editar ou criar arquivos no repositório do site — páginas, layouts, componentes, configuração Astro, conteúdo do blog ou arquivos públicos. Também use ao depurar builds, corrigir meta-tags, ajustar rotas ou qualquer tarefa que envolva o projeto Astro como um todo.
---

# Contexto do Projeto — fcoelds.dev.br

Site de personal branding de **Edson Lopes**, Consultor de Confiabilidade e Técnico de PCM.
Construído com **Astro v6.4.4**. Publicado em produção em `fcoelds.dev.br`.

## Propósito do site

Posicionamento profissional no nicho de **Confiabilidade Industrial e Gestão de Ativos**.
Público-alvo: recrutadores, indústrias brasileiras, comunidade ABRAMAN.
Tom: técnico, direto, sem buzzwords de marketing genérico.

## Estrutura esperada do repositório

```
/
├── astro.config.mjs          ← configuração central (site URL, integrações)
├── package.json
├── PRD.md                    ← este projeto
├── public/
│   ├── curriculo-edson-lopes.pdf
│   └── og-default.png        ← imagem OG (criar se não existir)
└── src/
    ├── pages/
    │   ├── index.astro       ← homepage
    │   ├── projetos.astro    ← portfólio de projetos
    │   ├── curriculo.astro   ← currículo profissional
    │   ├── about.md          ← página sobre (pode ser .astro)
    │   └── blog/
    │       └── index.astro   ← listagem de posts
    ├── content/
    │   └── blog/             ← arquivos .md ou .mdx dos posts
    ├── layouts/
    │   └── BaseLayout.astro  ← layout global com <head>, meta-tags, nav, footer
    └── components/
```

> A estrutura exata pode variar. **Sempre explorar o repositório antes de editar** — use `ls` e `cat` para confirmar nomes reais de arquivos.

## Regras críticas para edição

### 1. Nunca editar meta-tags individualmente por página

A correção canônica de SEO é feita **apenas** no `astro.config.mjs`:

```js
export default defineConfig({
  site: "https://fcoelds.dev.br", // ← esta linha resolve tudo
});
```

O Astro propaga automaticamente para todos os `<link rel="canonical">` e `og:url`.

### 2. Imagens OG ficam em `public/`

Arquivos em `public/` são servidos na raiz: `public/og-default.png` → `https://fcoelds.dev.br/og-default.png`.
Nos layouts, referenciar como `/og-default.png` (caminho absoluto, sem `public/`).

### 3. Conteúdo do blog em `src/content/blog/`

Posts são arquivos `.md` com frontmatter:

```yaml
---
title: "Título do post"
description: "Descrição para SEO"
pubDate: 2026-06-04
---
```

### 4. Frontmatter de páginas

Páginas `.md` usam frontmatter YAML. Páginas `.astro` definem meta via props do layout ou `<head>` inline.
Verificar o padrão usado antes de editar.

### 5. Zero lorem ipsum

Qualquer ocorrência de "lorem ipsum" em qualquer arquivo é um bug — reportar e corrigir.

### 6. Não remover conteúdo existente válido sem confirmar

Ao limpar o portfólio de projetos, **mover para comentário ou branch**, não deletar permanentemente sem confirmação.

## Como verificar o build

```bash
# Instalar dependências
npm install

# Build de produção
npm run build

# Preview local
npm run preview

# Verificar canonical em uma página (após build)
grep -r "canonical" dist/ | head -20
grep -r "og:url" dist/ | head -20
```

## Sinal de sucesso para TASK-01

Após corrigir `astro.config.mjs` e rodar build:

```bash
grep "fcoelds.dev.br" dist/index.html | grep canonical
# Deve retornar linha com: <link rel="canonical" href="https://fcoelds.dev.br/">
```

## Vocabulário do domínio (para não alterar inadvertidamente)

Termos técnicos corretos usados no site — não "corrigir" como se fossem erros:

- RAM, RBD, FTA, LDA, RGA — metodologias de confiabilidade
- PCM — Planejamento e Controle de Manutenção
- RCM — Reliability Centered Maintenance
- FMEA — Failure Mode and Effects Analysis
- PHM — Prognostics and Health Management
- MCDM — Multiple Criteria Decision Making
- Weibull, Crow-AMSAA — distribuições/modelos estatísticos
- N1 — nível de certificação Compass (não é erro de formatação)
