# PRD — Adequação do Site fcoelds.dev.br

> Product Requirements Document para uso com Claude Code

**Versão:** 1.0
**Data:** 06 de junho de 2026
**Repositório:** site Astro pessoal de Edson Lopes
**Objetivo:** Transformar o site de "beta público" em produto de personal branding pronto para posicionamento profissional como Consultor de Confiabilidade

---

## 1. Contexto

O site `fcoelds.dev.br` foi construído com **Astro v6.4.4** e está publicado, mas ainda em estado de desenvolvimento. Uma auditoria crítica identificou falhas técnicas, de conteúdo e de posicionamento organizadas em três ondas de prioridade.

Este PRD define o escopo completo do trabalho, os critérios de aceitação por tarefa e a ordem de execução recomendada para o Claude Code.

### Arquitetura atual

```
src/
├── pages/
│   ├── index.astro       ← homepage
│   ├── projetos.astro    ← portfólio
│   ├── blog/             ← notas técnicas
│   ├── curriculo.astro   ← currículo
│   └── about.md          ← sobre (com lorem ipsum)
├── components/
├── layouts/
└── content/
    └── blog/             ← arquivos .md dos posts

astro.config.mjs          ← canonical/site URL ERRADA aqui
public/
└── curriculo-edson-lopes.pdf
```

### Stack de deploy

- Astro v6.4.4
- Deploy: verificar `package.json` e configuração de CI

---

## 2. Ondas de trabalho

### 🔴 Onda 1 — Correções críticas (bloqueantes para SEO e credibilidade)

#### TASK-01 — Corrigir domínio canônico no Astro

**Problema:** `astro.config.mjs` tem `site: 'https://example.com'`, fazendo todas as meta-tags `canonical`, `og:url` e `twitter:url` apontarem para o domínio errado.

**Arquivo:** `astro.config.mjs`

**Mudança:**

```js
// ANTES
export default defineConfig({
  site: 'https://example.com',
})

// DEPOIS
export default defineConfig({
  site: 'https://fcoelds.dev.br',
})
```

**Critério de aceitação:**

- [ ] `astro.config.mjs` contém `site: 'https://fcoelds.dev.br'`
- [ ] Após build, `view-source` de qualquer página mostra `<link rel="canonical" href="https://fcoelds.dev.br/...">` com o domínio correto
- [ ] Meta `og:url` e `twitter:url` refletem o domínio correto em todas as páginas

---

#### TASK-02 — Criar imagem OG real

**Problema:** Todas as páginas usam `blog-placeholder-1.Bx0Zcyzv.jpg` como imagem Open Graph — thumbnail genérica do template Astro.

**O que criar:**

- Imagem `og-default.png` com dimensões **1200 × 630px**
- Conteúdo: nome "Edson Lopes", título "Confiabilidade · Gestão de Ativos · Dados", domínio `fcoelds.dev.br`
- Paleta: pode usar tons escuros industriais (grafite/carvão) com acento em âmbar ou ciano
- Salvar em `public/og-default.png`

**Atualização nos layouts:**

- Localizar o layout principal (provavelmente `src/layouts/BaseLayout.astro` ou similar)
- Substituir a referência à imagem placeholder pela nova OG

**Critério de aceitação:**

- [ ] Arquivo `public/og-default.png` existe com 1200×630px
- [ ] Meta `og:image` e `twitter:image` em todas as páginas apontam para `/og-default.png`
- [ ] Nenhuma referência a `blog-placeholder` permanece nos layouts globais

---

#### TASK-03 — Substituir lorem ipsum na página `/about`

**Problema:** `src/pages/about.md` (ou similar) contém texto lorem ipsum e meta-description `"Lorem ipsum dolor sit amet"` em produção.

**Conteúdo a inserir** (usar como base, ajustar tom se necessário):

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

**Critério de aceitação:**

- [ ] Página `/about` não contém nenhuma ocorrência de "lorem ipsum" ou "Lorem ipsum"
- [ ] Meta-description da página é diferente de "Lorem ipsum dolor sit amet"
- [ ] Conteúdo real está publicado

---

### 🟡 Onda 2 — Posicionamento (após Onda 1 concluída)

#### TASK-04 — Limpar portfólio de projetos

**Problema:** A página `/projetos` lista projetos genéricos que diluem o posicionamento especialista.

**Projetos a remover ou mover para seção separada:**

- "Conversor de Moedas em Java" → remover da página principal
- "Plataforma para Ar-condicionado" → remover ou mover para seção "experimentos"

**Critério de aceitação:**

- [ ] Página `/projetos` lista apenas projetos de confiabilidade, dados industriais e software aplicado
- [ ] Conversor de moedas e plataforma de ar-condicionado não aparecem no portfólio principal

---

#### TASK-05 — Adicionar foto profissional

**Problema:** Nenhuma página tem foto real. A página `/about` usa `blog-placeholder-about.webp`.

**Instrução:** Substituir a imagem placeholder por foto real quando disponível. Enquanto não houver foto, **remover** o elemento `<img>` da página `/about` em vez de manter o placeholder visível.

**Critério de aceitação:**

- [ ] Nenhuma imagem `blog-placeholder-about` aparece em produção
- [ ] Se foto real disponível: imagem renderiza com alt-text adequado

---

#### TASK-06 — Esclarecer formação acadêmica no currículo

**Problema:** As graduações em Administração (UNIFOR) e Ciência de Dados (UNINTER) aparecem sem indicação de status.

**Mudança:** Adicionar campo de status em cada formação:

```
Ciência de Dados — UNINTER · Em andamento
Administração — UNIFOR · Em andamento
```

**Critério de aceitação:**

- [ ] Cada formação em andamento tem indicação clara de status
- [ ] Não aparece como concluída sem ser

---

#### TASK-07 — Adicionar CTA de contato acessível

**Problema:** Não há forma clara de um visitante qualificado iniciar contato ou entender o que pode contratar.

**O que adicionar:**

- Na homepage, após a seção de projetos: bloco simples com texto tipo _"Disponível para projetos e consultorias"_ + botão de e-mail ou link para LinkedIn
- O e-mail já existe no rodapé, mas precisa de visibilidade maior no fluxo principal

**Critério de aceitação:**

- [ ] Existe pelo menos um CTA visível na homepage acima do fold de rodapé
- [ ] CTA leva a e-mail ou LinkedIn com um clique

---

### 🟢 Onda 3 — Identidade visual (trabalho futuro / fora do escopo imediato)

> As tarefas abaixo estão documentadas para referência futura. **Não executar nesta sprint.**

- **TASK-08:** Definir paleta de cores proprietária via CSS custom properties
- **TASK-09:** Escolher par tipográfico diferenciado (substituir fontes genéricas do template)
- **TASK-10:** Criar elementos visuais de identidade (ícones, ilustrações técnicas)
- **TASK-11:** Cadência editorial — publicar ao menos 2 notas técnicas por mês
- **TASK-12:** Integrar GitHub (`github.com/fcoelopes`) no header ou rodapé

---

## 3. Ordem de execução recomendada

```
TASK-01 → TASK-02 → TASK-03   (Onda 1, sequencial)
         ↓
TASK-04 → TASK-05 → TASK-06 → TASK-07   (Onda 2, pode ser paralelo)
         ↓
TASK-08..12   (Onda 3, futuro)
```

**Regra:** Não iniciar Onda 2 sem concluir todas as tasks da Onda 1.

---

## 4. Restrições e decisões de design

| Decisão     | Regra                                                                                                                        |
| ----------- | ---------------------------------------------------------------------------------------------------------------------------- |
| Framework   | Manter Astro — não migrar                                                                                                    |
| Conteúdo    | Não alterar copy existente além do especificado — apenas corrigir problemas identificados                                    |
| Lorem ipsum | Zero tolerância — nenhum placeholder em produção                                                                             |
| Imagens     | Não usar imagens de stock genéricas para substituir placeholders — criar ou remover                                          |
| Projetos    | Não criar novos cards de projeto — apenas remover os fora de escopo                                                          |
| SEO         | A correção do `site:` no Astro config é suficiente para resolver todos os canonicals — não hackear meta-tags individualmente |

---

## 5. Como usar com Claude Code

1. Adicionar este `PRD.md` na raiz do repositório
2. Adicionar as skills em `.claude/skills/` (ver pasta `skills/` neste pacote)
3. Iniciar sessão com: `claude` na raiz do projeto
4. Prompt sugerido de abertura:

```
Leia o PRD.md e as skills disponíveis. Vamos executar a Onda 1 completa:
TASK-01, TASK-02 e TASK-03. Comece pela TASK-01, mostre o diff antes de aplicar.
```

---

## 6. Referências

- Relatório de auditoria completo: `avaliacao-fcoelds-dev-br.md`
- Documentação Astro (SEO): https://docs.astro.build/en/guides/seo/
- Documentação Astro (site config): https://docs.astro.build/en/reference/configuration-reference/#site
