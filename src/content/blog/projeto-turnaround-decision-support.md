---
title: "Turnaround Decision Support — do planejamento-base ao replanejamento durante a parada"
description: "Aplicação para transformar cronogramas de parada em planos factíveis por recursos, analisar risco de prazo e replanejar a execução quando surgem restrições, achados e novo escopo."
pubDate: 2026-09-26
type: "project"
category: "Turnaround Decision Analytics"
status: "Em desenvolvimento"
progress: 80
readingTime: "13 min"
problem: "Cronogramas de grandes paradas podem estar logicamente corretos e ainda assim ser inviáveis por recursos, incerteza de duração ou novo escopo descoberto durante a execução."
application: "Planejamento e controle de turnarounds, shutdowns e grandes paradas de manutenção com forte dependência de precedências, equipes, recursos compartilhados e inspeções."
method: "CPM + RCPSP heurístico + Monte Carlo + baseline aprovado + MRCPSP + multi-skill + scope discovery + stability-aware rescheduling."
value: "Conectar planejamento, capacidade, risco e execução em um único fluxo de apoio à decisão, sem substituir o Microsoft Project."
stack: ["Python", "Streamlit", "RCPSP", "MRCPSP", "Monte Carlo", "SQLite", "SQLAlchemy"]
tags: ["Turnaround", "RCPSP", "MRCPSP", "Monte Carlo", "Planejamento", "Manutenção", "Decision Analytics", "Multi-skill"]
---

## Contexto

Grandes paradas de manutenção têm uma característica incômoda: o cronograma pode estar perfeitamente organizado no software de planejamento e ainda assim falhar quando encontra a realidade.

O Microsoft Project consegue representar atividades, precedências, datas e recursos. O problema começa quando surgem perguntas como:

- a sequência cabe realmente na quantidade de equipes disponível?
- qual recurso está alongando a parada?
- quanto da duração vem da lógica tecnológica e quanto vem da restrição de capacidade?
- qual é a probabilidade de cumprir a janela?
- o que acontece quando uma inspeção encontra um defeito que não existia no escopo inicial?
- como reprogramar o trabalho futuro sem destruir tudo que já foi comunicado às equipes?

O **Turnaround Decision Support** foi criado para trabalhar justamente nesse espaço.

Ele não tenta substituir o Microsoft Project. O cronograma continua sendo a referência de engenharia e planejamento. A aplicação acrescenta uma camada de **decision analytics** sobre esse cronograma.

A arquitetura foi dividida em dois momentos:

~~~text
PLANEJAMENTO
    ↓
plano factível + risco
    ↓
baseline aprovado
    ↓
ESCOPO E REPLANEJAMENTO
    ↓
execução + achados + novo escopo
    ↓
novo plano restante
~~~

Essa separação é importante porque planejar uma parada antes de começar e reprogramá-la durante a execução são problemas relacionados, mas não são o mesmo problema.

## 1. Guia Planejamento: preparar o plano que vai para a parada

A guia **Planejamento** trabalha principalmente com o problema pré-execução.

A pergunta central é:

> **Com o escopo conhecido, as precedências existentes e a capacidade real de recursos, qual cronograma é factível e qual é a exposição ao prazo?**

### Entrada do cronograma

A aplicação aceita XML exportado do Microsoft Project, Excel e CSV.

O XML é o formato mais rico porque preserva ID e UID, WBS/EDT, duração, predecessoras, relações FS/SS/FF/SF, lag, recursos, assignments, unidades e datas de início e término.

Depois da importação, todas as fontes são transformadas em um mesmo domínio interno de tarefas. Isso evita manter um motor para XML e outro para planilhas.

### CPM como referência sem restrição de recursos

Primeiro é calculada uma referência baseada na rede de precedências.

Essa camada responde aproximadamente:

> **Quanto a parada levaria se a única restrição fosse a lógica entre as atividades?**

O CPM fornece início e término mais cedo, início e término mais tarde, folga total e atividades com folga zero.

Essa referência permite separar duas causas diferentes de prazo:

~~~text
duração pela lógica da rede
          +
duração provocada por disputa de recursos
~~~

### RCPSP: tornar o cronograma factível por recursos

Depois entra o **Resource-Constrained Project Scheduling Problem — RCPSP**.

Uma atividade só pode iniciar quando suas precedências permitem e existe capacidade suficiente dos recursos exigidos.

Se três atividades puderem começar ao mesmo tempo, mas todas exigirem o mesmo guindaste e houver somente um disponível, o scheduler precisa sequenciá-las.

O motor atual usa um **Serial Schedule Generation Scheme** e compara quatro regras de prioridade:

- menor folga;
- maior número de sucessoras;
- maior duração;
- menor duração.

Cada regra gera um cronograma completo. A aplicação escolhe a solução com melhor aderência à deadline e menor makespan entre as alternativas avaliadas.

É um método heurístico: ele procura uma boa solução factível, mas não afirma provar o ótimo global.

### Capacidades como variável de decisão

As capacidades dos recursos podem ser alteradas para construir cenários.

Exemplo:

~~~text
Mecânica = 4
Elétrica = 2
Guindaste = 1
Inspeção = 2
~~~

e depois:

~~~text
Mecânica = 6
Elétrica = 2
Guindaste = 2
Inspeção = 2
~~~

A diferença entre os resultados ajuda a identificar onde aumentar capacidade realmente reduz a duração e onde apenas cria ociosidade.

A aplicação também calcula a **penalidade de recursos**. Se o CPM indicar 64 h e o cronograma factível por recursos terminar em 82 h:

~~~text
Penalidade de recursos = 82 - 64 = 18 h
~~~

Essas 18 h representam o tempo adicionado pela restrição de capacidade.

### Gantt factível

O Gantt mostra o resultado do RCPSP, preservando a ordem estrutural do planejamento para facilitar a leitura.

Quando o arquivo possui datas, o eixo pode ser apresentado em data e hora reais. Quando não possui, a visualização usa horas desde o início da parada.

As atividades críticas do CPM são destacadas, mas existe uma distinção importante:

> caminho crítico CPM e cadeia que controla um cronograma restrito por recursos não são necessariamente a mesma coisa.

Essa diferença fica ainda mais relevante na guia avançada.

### Monte Carlo e risco de prazo

Depois do cronograma determinístico, a aplicação adiciona incerteza às durações.

O usuário define um cenário triangular, por exemplo:

~~~text
otimista       -10%
mais provável    0%
pessimista      +30%
~~~

Em cada simulação, as durações são sorteadas e o RCPSP é executado novamente.

O resultado produz P50, P80, P90, distribuição do makespan e probabilidade de cumprir a janela.

Assim, a conversa deixa de ser apenas:

> “a parada termina em 9,4 dias”

e passa a ser:

> “o P80 está em 10,2 dias e a probabilidade estimada de cumprir a janela é 73%”.

Para planejamento de turnaround, essa segunda frase é mais útil.

### Saída para decisão

A visão executiva prioriza poucos indicadores:

- makespan;
- penalidade de recursos;
- P80;
- probabilidade de cumprir a janela.

Detalhes de cronograma, recursos, CPM, heurísticas e simulações ficam disponíveis para auditoria.

A aplicação também exporta relatório gerencial em PDF e dados técnicos em Excel.

Depois do replanejamento, o fluxo também pode devolver um **Microsoft Project XML (MSPDI)**. Esse arquivo materializa o snapshot operacional atual com condicionais já ativadas, atividades `DS-*` descobertas, precedências efetivas, recursos, modo escolhido e novos horários. O Project volta a ser o ambiente de comunicação e acompanhamento do cronograma, enquanto a lógica de decisão permanece no Turnaround Decision Support.

## 2. Aprovação do baseline: a ponte entre os dois mundos

Inicialmente, Planejamento e Escopo/Replanejamento eram duas páginas que compartilhavam o mesmo domínio, mas reconstruíam seus próprios cenários.

Isso criava um problema conceitual.

Um planejamento poderia produzir:

~~~text
RCPSP aprovado = 92 h
~~~

e a página avançada recalcular outro baseline:

~~~text
baseline MRCPSP = 97 h
~~~

Mesmo que ambos fossem matematicamente defensáveis, o usuário perdia a referência de qual plano havia sido realmente aprovado.

A solução foi criar uma transição explícita:

**Aprovar como baseline da execução**.

Quando um cenário é aprovado, o sistema persiste um snapshot contendo:

- tarefas;
- precedências;
- capacidades escolhidas;
- deadline;
- horários RCPSP;
- makespan;
- regra heurística selecionada;
- P80 e probabilidade de cumprir a janela, quando disponíveis.

Cada baseline recebe uma identidade por fingerprint SHA-256.

A partir desse momento, aquele plano deixa de ser somente um cenário de estudo e passa a ser a referência da execução.

~~~text
cronograma original
        ↓
cenários de capacidade
        ↓
RCPSP + risco
        ↓
cenário escolhido
        ↓
BASELINE APROVADO
        ↓
execução
~~~

## 3. Guia Escopo e Replanejamento: controlar o que acontece depois que a parada começa

A segunda guia trabalha com outro problema.

A pergunta passa a ser:

> **Dado o plano aprovado e tudo que aconteceu desde o início da parada, como programar o trabalho restante?**

A página pode receber um baseline aprovado diretamente da guia Planejamento, um XML carregado diretamente ou um cenário demonstrativo.

Quando existe baseline aprovado, esse é o caminho preferencial.

### Operação: estado atual da parada

A aba **Operação** representa a execução.

O planejador informa a hora corrente da parada.

A partir disso, atividades concluídas e atividades em andamento são congeladas. Somente o trabalho futuro pode ser reprogramado.

Isso impede que o solver “reescreva o passado” para encontrar uma solução mais bonita.

### Escopo condicional

Uma parada contém trabalhos conhecidos antecipadamente, mas que só devem entrar no escopo se determinada condição ocorrer.

Exemplo:

~~~text
Inspecionar eixo
      ↓
trinca_detectada?
      ↓ sim
Reparar eixo
~~~

Essas atividades podem ser cadastradas como **conditional**.

A interface possui um editor de regras em formato de planilha. O planejador define atividade alvo, atividade gatilho, evento, lógica any/all e observação.

As regras são validadas antes de serem persistidas.

### XOR, OR e AND

Nem toda descoberta significa simplesmente “executar uma atividade”.

Alguns achados abrem alternativas.

~~~text
Inspeção do impelidor
        ↓
      dano
        ↓
  ┌─────┴─────┐
reparar     substituir
~~~

Isso pode ser modelado como XOR: exatamente uma alternativa será escolhida.

Também existem OR, em que uma ou mais alternativas podem entrar, e AND, em que todas as atividades do grupo entram.

Quando a escolha é técnica, o scheduler não decide sozinho com base em prazo. Ele calcula cenários de impacto e mantém a decisão com o planejador.

### Dynamic Scope Discovery

Existe uma diferença importante entre **escopo condicional** e **escopo realmente novo**.

Escopo condicional significa que o trabalho já existia no planejamento, mas aguardava um gatilho.

Dynamic scope significa que o trabalho não existia no cronograma.

~~~text
Inspecionar carcaça
       ↓
trinca inesperada
       ↓
DS-001 · Reparar trinca
       ↓
Fechar equipamento
~~~

A atividade DS-001 recebe duração, recursos, custo, hora da descoberta, origem, predecessoras e atividades futuras que deve bloquear.

A aplicação injeta esse trabalho no projeto efetivo sem alterar o baseline original.

### MRCPSP: múltiplos modos de execução

Na execução, uma atividade pode ter mais de uma forma possível de ser realizada.

~~~text
Reparo convencional
12 h
Mecânica: 2

Reparo acelerado
8 h
Mecânica: 3
Guindaste: 1
~~~

Esse problema pertence à família do **Multi-Mode Resource-Constrained Project Scheduling Problem — MRCPSP**.

Cada modo pode alterar duração, recursos e custo. O scheduler avalia a factibilidade dos modos dentro do cenário atual.

### Pessoas e multi-skill

A aba **Pessoas** modela recursos humanos no nível individual.

Uma pessoa pode ter múltiplas habilidades:

~~~text
Ana
- Mecânica
- Soldagem
~~~

Mas Ana continua sendo uma única pessoa. Ela não pode ser usada simultaneamente como mecânica em uma atividade e como soldadora em outra.

A aplicação faz matching entre pessoas, habilidades e vagas exigidas pelas atividades.

Recursos não humanos, como guindastes ou ferramentas especiais, continuam tratados por capacidade agregada.

### Configuração

A aba **Configuração** concentra parâmetros que alteram a execução:

- regras de escopo;
- capacidades;
- modos;
- recursos não cadastrados;
- preferência de estabilidade do replanejamento;
- histórico persistido da sessão.

A separação mantém a aba Operação orientada ao que está acontecendo na parada, em vez de misturar execução com configuração do modelo.

## 4. Stability-aware rescheduling

Replanejar uma parada não significa simplesmente buscar o menor makespan possível.

Imagine que dois cronogramas terminem praticamente no mesmo horário:

~~~text
Plano A
muda 3 atividades

Plano B
muda 18 atividades
~~~

O Plano B pode causar muito mais impacto operacional, porque equipes precisam receber nova programação, recursos compartilhados precisam ser coordenados novamente e decisões já comunicadas perdem valor.

Por isso o projeto inclui uma penalidade de estabilidade.

Para cada atividade futura que já possuía horário:

~~~text
desvio_j = |novo início_j - início aprovado_j|
~~~

O objetivo considera:

~~~text
atraso à deadline
        ↓
makespan + λ × soma dos deslocamentos
        ↓
maior deslocamento individual
        ↓
custo
~~~

O parâmetro λ controla quanto o modelo deve valorizar a estabilidade.

Atividades DS-* não recebem penalidade, porque nunca tiveram horário no baseline.

## 5. Como as duas guias se integram

A integração pode ser resumida assim.

### Planejamento responde

> **Qual plano faz sentido levar para a parada?**

Ele trabalha com escopo conhecido, precedências, capacidade, CPM, RCPSP, Gantt, risco Monte Carlo e aderência à janela.

A saída é um **baseline aprovado**.

### Escopo e Replanejamento responde

> **Dado o baseline aprovado e o que realmente aconteceu, qual deve ser o plano restante?**

Ele acrescenta estado da execução, congelamento do realizado, eventos, novo escopo, regras conditional/XOR/OR/AND, múltiplos modos, pessoas multi-skill, MRCPSP e estabilidade do replanejamento.

A referência continua sendo o baseline aprovado.

Se o modelo avançado permanecer compatível com o plano original, a execução começa exatamente nos horários RCPSP aprovados.

Se regras, modos ou multi-skill exigirem reconstrução, o MRCPSP pode recalcular a programação operacional, mas os horários aprovados continuam sendo a referência usada para medir deslocamentos.

~~~text
Project
  ↓
Planejamento
  ↓
RCPSP
  ↓
Monte Carlo
  ↓
Baseline aprovado
  ↓
────────────────────────────
  ↓ início da execução
  ↓
Escopo e Replanejamento
  ↓
estado + eventos + pessoas
  ↓
scope discovery
  ↓
MRCPSP
  ↓
stability-aware rescheduling
  ↓
novo plano restante
~~~

Isso preserva a história da decisão: o sistema consegue distinguir o plano original, o baseline que foi aprovado e o plano que passou a valer depois dos eventos da execução.

## 6. Persistência e rastreabilidade

A execução é persistida em SQLite usando SQLAlchemy e Alembic.

São armazenados:

- baselines aprovados;
- sessões de execução;
- hora corrente;
- capacidades do cenário;
- regras de escopo;
- eventos;
- decisões humanas;
- atividades descobertas DS-*;
- alterações da sessão.

O objetivo é evitar que a aplicação seja apenas um simulador de tela.

Uma parada precisa manter memória de:

> o que estava aprovado, o que aconteceu e por que o plano atual está diferente.

## 7. O que o sistema não tenta fazer

O Turnaround Decision Support não pretende substituir o Microsoft Project, o julgamento técnico da manutenção, a decisão humana entre reparar ou substituir ou as ferramentas corporativas de gestão da execução.

A proposta é complementar essas ferramentas com modelos que normalmente exigiriam análises separadas e devolver ao Microsoft Project o cronograma operacional já materializado depois das decisões e do replanejamento.

Também existem limitações atuais:

- o RCPSP é heurístico e não prova ótimo global;
- ainda não existe calendário completo por turno e indisponibilidade individual;
- a camada Monte Carlo atual perturba principalmente durações;
- proficiência e produtividade por skill ainda não são modeladas;
- o deploy atual usa SQLite e é orientado a uma instância única.

O núcleo foi separado da interface justamente para permitir evolução posterior para CP-SAT/MILP e calendários mais ricos.

## 8. Onde isso pode gerar valor

O projeto faz mais sentido em ambientes onde a duração da parada depende fortemente de recursos compartilhados, equipes especializadas, guindastes, inspeções que liberam ou criam escopo e alto custo de extensão da janela.

O ganho não está em “gerar mais um cronograma”.

Está em tornar algumas perguntas explícitas e calculáveis:

> Qual é a penalidade real da restrição de recursos?

> Qual capacidade adicional realmente reduz o prazo?

> Qual é o risco de cumprir a janela?

> Quanto novo escopo adicionou ao término?

> Quais atividades passaram a controlar a conclusão?

> Quanto o novo plano se afastou daquele que foi comunicado às equipes?

Essas são perguntas de decisão, não apenas de desenho de cronograma.

## Aplicação

A versão em desenvolvimento está disponível em:

[turnaround.fcoelds.dev.br](https://turnaround.fcoelds.dev.br)

## Código

O projeto é público no GitHub:

[github.com/fcoelopes/turnaround-project](https://github.com/fcoelopes/turnaround-project)
