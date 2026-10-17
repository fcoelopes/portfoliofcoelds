---
title: "Sharc Tank — uma incubadora de oportunidades que ainda não conhecemos"
description: "A proposta de um laboratório multiagente que descobre hipóteses de negócios em qualquer setor, conecta evidências, debate investimentos e transforma incertezas em experimentos."
pubDate: "2026-10-17"
type: "project"
showInBlog: true
category: "Empreendedorismo, IA e avaliação de investimentos"
status: "Em desenvolvimento"
readingTime: "7 min"
problem: "Boas oportunidades podem passar despercebidas enquanto decisões de investimento são feitas com evidências insuficientes e sem considerar as alternativas para o capital."
application: "Descoberta, avaliação econômica e experimentação de oportunidades em qualquer mercado."
method: "Agentes de pesquisa + comitê adversarial + motores financeiros determinísticos + grafo de conhecimento."
value: "Decisões de alocação de capital explicáveis, experimentos mais baratos e aprendizado cumulativo."
stack: ["Deep Agents", "LangChain", "LangGraph", "LangSmith", "Knowledge Graph", "Python", "PostgreSQL"]
tags: ["Sharc Tank", "Empreendedorismo", "Multiagentes", "Finanças", "Knowledge Graph"]
---

> **A ideia central:** não automatizar ideias de negócios que já tivemos, mas descobrir oportunidades que jamais consideraríamos, submetê-las a um exame crítico e aprender quais merecem nosso tempo e capital.

[**Conheça a apresentação do Sharc Tank →**](/sharc-tank/)

## O pitch

E se existisse uma incubadora que não esperasse um empreendedor chegar com uma ideia?

Uma organização de agentes de inteligência artificial poderia explorar sinais econômicos, problemas mal resolvidos e mercados emergentes; formular hipóteses de negócios; procurar evidências contrárias às próprias descobertas; e reunir um comitê de especialistas para discutir riscos, retorno e custo de oportunidade.

Ao final, em vez de uma lista de *negócios imperdíveis*, teríamos um portfólio vivo de possibilidades: o que sabemos, o que ainda estamos supondo, quanto precisaria ser investido, que alternativas estão sendo sacrificadas e qual experimento de baixo custo poderia mudar a decisão.

**Essa é a visão do Sharc Tank.**

## Por que criar isso?

Uma ideia pode parecer promissora no papel e destruir caixa na operação. Outra pode ser menos chamativa, mas exigir pouco capital, permitir uma validação rápida e abrir caminhos inesperados.

A avaliação precisa ir além do entusiasmo: demanda, concorrência, margem de contribuição, capital de giro, riscos, cenários, liquidez e o custo de não escolher outra alternativa. Também precisamos reconhecer um resultado perfeitamente válido: **ainda não há evidência suficiente para investir**.

O Sharc Tank é um projeto pessoal de aprendizado aplicado que aproxima empreendedorismo, *Corporate Finance*, engenharia de dados, grafos de conhecimento e sistemas de agentes. Não nasce limitado à indústria, ao comércio, ao setor financeiro ou à tecnologia. Seu campo de investigação é deliberadamente aberto.

## Três camadas de inteligência

### 1. Descoberta — encontrar o que não estávamos procurando

Agentes investigadores deverão observar fontes autorizadas e sinais de mercado, localizar necessidades mal atendidas, comparar soluções existentes e formular hipóteses originais.

Uma oportunidade será registrada com seu problema, cliente potencial, proposta de valor, modelo de receita, sinais de demanda e dúvidas críticas. Hipóteses não serão confundidas com fatos observados.

### 2. Avaliação — o Shark Tank que questiona as próprias teses

Uma equipe de agentes com papéis distintos examinará cada hipótese. O analista de mercado discutirá concorrência e demanda; o financeiro avaliará viabilidade; o cético procurará razões para não investir; e o analista de custo de oportunidade comparará usos alternativos do mesmo capital.

É aqui que entram **VPL (valor presente líquido), TIR (taxa interna de retorno), ROE (retorno sobre o patrimônio líquido), ROIC (retorno sobre o capital investido), EVA (valor econômico agregado)** e modelos de fluxo de caixa. Os cálculos deverão ser executados por rotinas matemáticas auditáveis; os agentes formulam perguntas, apresentam premissas e interpretam resultados.

O debate deve preservar divergências. Um pitch convincente não substitui evidências, nem um retorno projetado representa lucro realizado.

### 3. Incubadora — trocar certezas prematuras por experimentos

As hipóteses mais interessantes avançam para experimentos: entrevista com clientes, teste de demanda, orçamento de fornecedor, pré-venda autorizada ou outro método adequado ao mercado.

Cada experimento deverá ter orçamento, duração, métrica observável, hipótese falsificável e condições claras para interromper, adaptar ou avançar. A proposta é gastar pouco para aprender antes de comprometer muito capital.

## Custo de oportunidade: a pergunta mais importante

Avaliar um negócio isoladamente pode ser enganoso. Todo investimento concorre com outros usos para o mesmo dinheiro, tempo e atenção.

O Sharc Tank pretende comparar alternativas levando em conta risco, prazo, liquidez, impostos e esforço operacional. **Não investir** ou **esperar por novas evidências** são alternativas legítimas. Uma oportunidade pode oferecer retorno elevado e ainda assim ser a escolha errada diante do conjunto de possibilidades.

A prioridade não será apenas selecionar o negócio com o melhor número projetado, mas identificar **onde o próximo real investido em investigação pode produzir informação relevante**.

## Um grafo para conectar descobertas

Relatórios desconectados esquecem o passado. Um **Knowledge Graph** pode conectar problemas, tecnologias, segmentos de clientes, organizações, concorrentes, fornecedores, riscos e evidências.

Imagine uma investigação revelar uma mudança regulatória. A mesma informação poderá afetar custos de várias oportunidades já catalogadas. O grafo permitiria navegar por essas relações e reavaliar hipóteses sem começar do zero.

Cada vínculo precisa registrar origem e contexto. Uma correlação sugerida por IA não deve virar relação causal sem validação.

## A arquitetura pensada para isso

- **Deep Agents e LangChain:** agentes de pesquisa, delegação e uso de ferramentas.
- **LangGraph:** estado, execução por etapas, interrupções e retomadas.
- **LangSmith:** observabilidade e avaliação da qualidade dos agentes, quando habilitado.
- **Knowledge Graph:** relações econômicas e proveniência de evidências.
- **PostgreSQL e Python:** histórico durável, contratos de dados e cálculos financeiros reproduzíveis.

O projeto foi pensado para operar em uma VPS, com tarefas sob demanda e agendas futuras. Um serviço 24×7 não significa consumir tokens a cada segundo; significa estar disponível para trabalhar quando houver uma missão.

## O que existe hoje — e o que ainda é visão

O Sharc Tank está em **fase de fundação de engenharia**. Já foram estruturados requisitos, documentação arquitetural, controles de qualidade, uma API mínima e rotinas financeiras iniciais para testes. Isso não significa que a descoberta automatizada, o grafo econômico persistente ou o comitê de investimentos já estejam operacionais.

Os próximos marcos são conectar pesquisa real e verificável, persistir hipóteses com proveniência, aprofundar a avaliação econômica e experimentar o debate entre agentes. Somente depois faz sentido automatizar o ciclo completo.

## A medida do sucesso

O Sharc Tank não será julgado pelo número de ideias geradas nem pela eloquência dos pitches. Seu valor estará na capacidade de encontrar oportunidades fora do nosso radar, formular perguntas melhores, evitar decisões ruins e tornar cada experimento uma fonte de aprendizado.

> **Discover opportunities. Challenge assumptions. Allocate capital intelligently.**

A primeira grande prova será simples de enunciar — e difícil de executar: **descobrir uma oportunidade que não estávamos procurando, fundamentá-la com evidências e definir o menor experimento útil para testá-la.**
