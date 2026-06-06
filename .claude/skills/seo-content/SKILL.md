---
name: seo-content-fix
description: Guia de execução para as correções de SEO técnico e conteúdo do site fcoelds.dev.br conforme PRD.md. Use esta skill ao executar qualquer TASK do PRD — especialmente TASK-01 (canonical), TASK-02 (imagem OG), TASK-03 (lorem ipsum), TASK-04 (portfólio), TASK-06 (formação) e TASK-07 (CTA). Contém critérios de aceitação, diffs esperados e checklists de verificação para cada tarefa.
---

# Guia de Execução — Correções SEO e Conteúdo

Este guia detalha como executar cada TASK do `PRD.md`. Sempre leia a task completa antes de editar qualquer arquivo.

## Fluxo obrigatório para qualquer TASK

```
1. Explorar → entender estrutura real do repositório
2. Ler → arquivo a ser editado na íntegra
3. Planejar → mostrar diff pretendido ao usuário
4. Confirmar → aguardar aprovação antes de aplicar
5. Aplicar → fazer a mudança
6. Verificar → rodar checklist de aceitação
```

**Nunca pular a etapa de confirmação.** Mostrar sempre o before/after antes de editar.

---

## TASK-01 — Corrigir domínio canônico

### Localizar o arquivo
```bash
cat astro.config.mjs
```

### Diff esperado
```diff
- site: 'https://example.com',
+ site: 'https://fcoelds.dev.br',
```

### Verificação pós-edição
```bash
npm run build 2>&1 | tail -5

# Verificar canonical na homepage
grep -o 'canonical.*fcoelds' dist/index.html

# Verificar og:url
grep -o 'og:url.*fcoelds' dist/index.html

# Verificar que example.com sumiu
grep -r "example.com" dist/ | grep -v ".map" | wc -l
# Deve retornar 0
```

### ✅ Critérios de aceitação
- [ ] `astro.config.mjs` contém `site: 'https://fcoelds.dev.br'`
- [ ] Build passa sem erros
- [ ] `grep "example.com" dist/` retorna 0 resultados (excluindo sourcemaps)
- [ ] `grep "canonical" dist/index.html` mostra `fcoelds.dev.br`

---

## TASK-02 — Imagem OG real

### Estratégia
Como Claude Code não gera imagens, a abordagem é:

**Opção A (preferida):** Criar um componente HTML/SVG que sirva como OG placeholder com branding real, convertendo para PNG via script.

**Opção B (imediata):** Atualizar o layout para referenciar uma imagem que o usuário vai fornecer, e remover a referência ao placeholder do template.

### Localizar referência atual
```bash
grep -r "blog-placeholder" src/
```

### Localizar o layout principal
```bash
ls src/layouts/
cat src/layouts/BaseLayout.astro  # ou o layout encontrado
```

### Mudança no layout
Substituir a referência hardcoded ao placeholder por uma variável com fallback:

```astro
<!-- ANTES (exemplo) -->
<meta property="og:image" content="/_astro/blog-placeholder-1.Bx0Zcyzv.jpg" />

<!-- DEPOIS -->
<meta property="og:image" content={ogImage ?? '/og-default.png'} />
```

### Criar arquivo placeholder de OG
Se o usuário ainda não tiver a imagem, criar um arquivo `public/og-default.png` vazio como marcador e avisar:

```bash
# Notificar usuário que og-default.png precisa ser criada manualmente
# com dimensões 1200x630px e conteúdo:
# - Nome: "Edson Lopes"
# - Título: "Confiabilidade · Gestão de Ativos · Dados"
# - Domínio: fcoelds.dev.br
```

### ✅ Critérios de aceitação
- [ ] Nenhuma referência a `blog-placeholder` em `src/layouts/`
- [ ] Meta `og:image` aponta para `/og-default.png` ou variável controlada
- [ ] Usuário ciente de que precisa criar a imagem com 1200×630px

---

## TASK-03 — Substituir lorem ipsum no /about

### Localizar arquivo
```bash
# Procurar por lorem ipsum em todo o src/
grep -rl "lorem ipsum" src/ --include="*.md" --include="*.astro" --include="*.mdx"
```

### Verificar frontmatter atual
```bash
cat src/pages/about.md  # ou o arquivo encontrado
```

### Conteúdo a inserir
Substituir **todo o conteúdo** (frontmatter + body) pelo seguinte, preservando o formato do arquivo (`.md` ou `.astro`):

**Para arquivo `.md`:**
```markdown
---
title: "Sobre"
description: "Confiabilidade, dados e software aplicados à decisão sobre ativos industriais."
---

# Sobre mim

Sou Edson Lopes, Técnico de PCM e Confiabilidade com mais de 15 anos de experiência
em ambientes industriais reais — do chão de fábrica da HEINEKEN ao planejamento
preditivo na ArcelorMittal Pecém.

Meu trabalho é conectar engenharia de confiabilidade, análise de dados e software
para apoiar decisões sobre ativos industriais. Não apenas calcular indicadores,
mas transformar dados técnicos em critérios úteis para quem decide sobre manutenção,
paradas e gestão de ativos.

## Como trabalho

Aplico técnicas como RAM, RBD, Weibull, RCM, FMEA, MCDM e modelos de degradação
em problemas concretos — sempre com foco na decisão que precisa ser tomada, não
na ferramenta pela ferramenta.

Estou desenvolvendo ferramentas próprias que combinam Python, dados industriais e
inteligência artificial aplicada à confiabilidade: da estimativa de RUL ao
diagnóstico de transformadores de potência.

## Além do trabalho

Membro ativo da ABRAMAN. Pesquisador aplicado, com interesse em publicações nas
intersecções entre MCDM, confiabilidade e machine learning para manutenção industrial.
Cursando simultaneamente Ciência de Dados e Administração.

Baseado no Ceará, Brasil.
```

### Remover imagem placeholder
```bash
# Verificar se há referência à imagem placeholder no about
grep -r "blog-placeholder-about" src/
```
Se encontrada, remover o elemento `<img>` — não substituir por outro placeholder.

### ✅ Critérios de aceitação
- [ ] `grep -r "lorem ipsum" src/` retorna 0 resultados
- [ ] Meta-description da página about ≠ "Lorem ipsum dolor sit amet"
- [ ] Página renderiza com conteúdo real em `npm run preview`
- [ ] Nenhuma imagem `blog-placeholder-about` visível

---

## TASK-04 — Limpar portfólio

### Localizar projetos a remover
```bash
grep -n "Conversor\|Ar-condicionado\|Java\|moedas" src/pages/projetos.astro
```

### Estratégia de remoção
1. Comentar os blocos dos projetos genéricos (não deletar)
2. Mostrar diff ao usuário antes de aplicar
3. Perguntar se prefere deletar ou apenas ocultar

### ✅ Critérios de aceitação
- [ ] "Conversor de Moedas" não aparece na página `/projetos` em produção
- [ ] "Plataforma para Ar-condicionado" não aparece na página `/projetos` em produção
- [ ] Projetos restantes são todos de confiabilidade/dados industriais/software aplicado

---

## TASK-06 — Status da formação no currículo

### Localizar
```bash
grep -n "UNIFOR\|UNINTER\|Administração\|Ciência de Dados" src/pages/curriculo.astro
```

### Mudança esperada
Adicionar indicação de status após cada graduação em andamento:
```
Ciência de Dados — UNINTER · Em andamento
Administração — UNIFOR · Em andamento
```

### ✅ Critérios de aceitação
- [ ] Graduações em andamento têm indicação explícita de status

---

## TASK-07 — CTA de contato

### Localizar seção de contato na homepage
```bash
grep -n "contato\|email\|linkedin\|CTA\|contact" src/pages/index.astro -i
```

### O que adicionar
Bloco simples após a seção de projetos na homepage:

```astro
<!-- Seção CTA -->
<section>
  <h2>Vamos conversar?</h2>
  <p>Disponível para projetos, consultorias e colaborações em confiabilidade e gestão de ativos.</p>
  <a href="mailto:contato@fcoelds.dev.br">Enviar e-mail</a>
  <a href="https://www.linkedin.com/in/franciscoedsonlopessilva" target="_blank">LinkedIn</a>
</section>
```

Adaptar ao padrão de estilo e componentes já existentes no projeto.

### ✅ Critérios de aceitação
- [ ] Existe pelo menos um CTA visível na homepage antes do rodapé
- [ ] CTA tem link funcional para e-mail ou LinkedIn
- [ ] Estilo é consistente com o restante da página

---

## Erros comuns a evitar

| Erro | Correção |
|---|---|
| Editar `<head>` de cada página individualmente para SEO | Editar apenas `astro.config.mjs` — o Astro propaga automaticamente |
| Usar `href="mailto:..."` com e-mail ofuscado do Cloudflare | Verificar se o e-mail no HTML é texto puro ou hash Cloudflare; usar o e-mail real `contato@fcoelds.dev.br` |
| Deletar projetos sem confirmar | Comentar primeiro, confirmar com usuário antes de deletar |
| Assumir estrutura de arquivos sem explorar | Sempre `ls src/pages/` e `ls src/layouts/` antes de editar |
| Criar nova imagem OG via código quando não é possível | Informar usuário e preparar o layout para receber a imagem quando ela for criada |