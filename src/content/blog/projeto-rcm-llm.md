---

title: "RCM com LLM — assistente para análise de manutenção centrada em confiabilidade"
description: "Como um assistente de IA pode estruturar e padronizar análises de RCM em equipes de manutenção industrial."
pubDate: 2026-06-03
type: "project"

category: "Reliability Engineering"
status: "PoC"
progress: 30
readingTime: "8 min"

problem: "Análises RCM demoradas, dependentes de especialista sênior e difíceis de padronizar entre equipes."
application: "Manutenção centrada em confiabilidade em plantas industriais, utilidades e manutenção pesada."
method: "LLM + estrutura RCM + base técnica + fluxo orientado à decisão."
value: "Padronização, rastreabilidade e apoio técnico à decisão de manutenção."

stack: ["Python", "Streamlit", "Terraform", "Claude API"]
tags: ["RCM", "LLM", "FMEA", "Confiabilidade", "Manutenção"]


## Contexto

A Manutenção Centrada em Confiabilidade, ou RCM, é uma abordagem estruturada para definir o que deve ser feito para garantir que um ativo continue cumprindo suas funções no contexto operacional em que está inserido.

Na teoria, o processo é bastante claro: compreender as funções do ativo, identificar falhas funcionais, levantar modos de falha, avaliar efeitos e consequências, e então selecionar tarefas de manutenção tecnicamente justificáveis.

Na prática, porém, a aplicação costuma ser bem menos organizada.

Muitas análises ficam presas em planilhas extensas, documentos pouco padronizados e discussões que dependem fortemente da experiência de um facilitador sênior. Quando esse profissional muda de área, sai da empresa ou simplesmente deixa de acompanhar o processo, boa parte do raciocínio técnico se perde.

> A ideia deste projeto é investigar como um assistente baseado em LLM pode apoiar a estruturação, documentação e padronização de análises RCM sem substituir o julgamento técnico do especialista.

## O problema

Em ambientes industriais, uma análise RCM raramente falha por falta de teoria. O problema costuma estar na execução.

A equipe sabe que precisa discutir funções, falhas, modos de falha, efeitos e tarefas. Mas o processo frequentemente se torna demorado, heterogêneo e difícil de auditar.

Algumas dificuldades aparecem com frequência:

* cada facilitador conduz a análise de um jeito;
* os critérios de decisão nem sempre ficam explícitos;
* os registros acabam espalhados em planilhas, atas e documentos;
* a qualidade final depende demais da experiência individual;
* análises antigas são difíceis de reutilizar;
* o vínculo entre falha, consequência e tarefa nem sempre fica claro.

Isso cria um problema importante para a gestão de ativos: a decisão de manutenção pode até estar correta, mas nem sempre está bem documentada, rastreável ou padronizada.

## Por que usar LLM nesse contexto?

Modelos de linguagem não devem decidir sozinhos qual tarefa de manutenção aplicar. Essa decisão exige conhecimento do ativo, histórico de falhas, contexto operacional, consequências, restrições de segurança, custos e experiência prática.

Mas LLMs podem ser úteis em outra camada: a camada de estruturação do raciocínio.

Um assistente pode ajudar a organizar perguntas, manter consistência na terminologia, revisar lacunas, sugerir pontos de atenção e transformar discussões técnicas em registros mais claros.

Nesse sentido, o LLM não entra como “oráculo técnico”, mas como apoio à condução da análise.

A proposta é que a decisão continue humana, mas o processo fique mais guiado, documentado e reutilizável.

## Proposta da solução

O projeto propõe um assistente para apoiar análises de Manutenção Centrada em Confiabilidade em um fluxo orientado por etapas.

A ideia inicial é conduzir o usuário por uma sequência estruturada:

1. definição do ativo ou sistema analisado;
2. descrição do contexto operacional;
3. identificação das funções principais e secundárias;
4. levantamento das falhas funcionais;
5. identificação dos modos de falha;
6. descrição dos efeitos locais, sistêmicos e operacionais;
7. avaliação das consequências;
8. sugestão e validação de tarefas de manutenção;
9. documentação da justificativa técnica;
10. geração de uma saída padronizada.

O objetivo não é automatizar a RCM de ponta a ponta. O objetivo é reduzir a desorganização do processo e apoiar o especialista a manter coerência entre problema, consequência e ação recomendada.

## O papel do especialista

Uma preocupação importante neste projeto é não confundir automação com substituição de julgamento técnico.

O assistente pode sugerir perguntas, organizar respostas e indicar inconsistências. Mas quem valida a análise continua sendo o profissional responsável pela manutenção, confiabilidade ou engenharia.

Por exemplo, o assistente pode perguntar se um modo de falha tem consequência de segurança, operacional, ambiental ou econômica. Mas a avaliação real dessa consequência depende do contexto da planta, do histórico do ativo e da criticidade do processo.

Da mesma forma, o assistente pode sugerir que uma tarefa preditiva seja considerada. Mas a viabilidade dessa tarefa depende de sensores disponíveis, acesso ao ativo, periodicidade, custo, detectabilidade da falha e capacidade da equipe.

Em outras palavras: o assistente organiza o raciocínio; o especialista decide.

## Arquitetura inicial

A primeira versão do projeto está sendo pensada como uma prova de conceito simples, com foco na validação do fluxo.

A arquitetura inicial considera uma interface em Streamlit, uma camada de prompts estruturados, uma base de conhecimento técnico e chamadas a um modelo de linguagem para apoiar a geração e revisão das respostas.

O fluxo esperado é simples:

1. o usuário informa o ativo e o contexto operacional;
2. o sistema conduz perguntas de RCM em etapas;
3. o LLM ajuda a estruturar respostas e apontar lacunas;
4. o especialista revisa, corrige e valida;
5. o sistema gera uma saída consolidada.

A saída pode assumir a forma de relatório técnico, tabela estruturada ou base reutilizável para revisões futuras.

## Exemplo de aplicação

Imagine uma bomba centrífuga crítica em um sistema de utilidades industriais.

Em uma análise tradicional, a equipe pode registrar funções, falhas e modos de falha em uma planilha. Porém, se o preenchimento for feito sem padronização, alguns modos de falha podem ficar vagos, efeitos podem ser descritos de forma incompleta e tarefas podem ser escolhidas sem justificativa clara.

Com o assistente, o processo pode ser conduzido de forma mais controlada.

Ao registrar uma falha funcional, o sistema pode perguntar quais funções deixaram de ser atendidas. Ao informar um modo de falha, pode solicitar o mecanismo físico envolvido. Ao propor uma tarefa, pode questionar se ela é tecnicamente aplicável, se existe intervalo viável e se a falha apresenta algum padrão detectável.

Essa sequência ajuda a evitar respostas genéricas e melhora a rastreabilidade da decisão.

## O que o projeto não é

Este projeto não é um sistema mágico para gerar planos de manutenção automaticamente.

Também não é uma tentativa de substituir normas, especialistas ou metodologias consolidadas.

O projeto deve ser entendido como uma camada de apoio à aplicação prática da RCM. Ele busca melhorar a qualidade do registro, a consistência das análises e a clareza das justificativas.

Algumas limitações precisam ser reconhecidas desde o início:

* o modelo pode sugerir respostas tecnicamente plausíveis, mas incorretas;
* a qualidade da saída depende da qualidade das informações fornecidas;
* a validação de campo continua indispensável;
* a análise precisa respeitar o contexto operacional real;
* decisões críticas não devem ser tomadas sem revisão técnica.

Essas limitações não invalidam o uso de LLMs. Apenas definem o lugar correto da ferramenta.

## Estado atual

O projeto está em fase de prova de conceito.

Nesta etapa, o foco não é construir um produto completo, mas validar se o fluxo de análise pode ser estruturado de forma útil para um caso industrial real.

Os pontos já definidos são:

* estrutura conceitual do fluxo RCM;
* campos principais da análise;
* papel do LLM como apoio, não decisor;
* necessidade de rastreabilidade das respostas;
* proposta inicial de interface;
* stack preliminar com Python, Streamlit e API de LLM.

O próximo passo é aplicar o fluxo em um ativo específico e comparar a experiência com uma análise feita de forma convencional.

## Critérios de sucesso

Para avaliar se a ideia faz sentido, alguns critérios precisam ser observados.

O primeiro é a clareza. A análise gerada precisa ser mais compreensível do que uma planilha solta.

O segundo é a rastreabilidade. Deve ser possível entender por que uma tarefa foi recomendada, rejeitada ou deixada para análise posterior.

O terceiro é a consistência. O sistema deve ajudar a manter o vínculo entre função, falha funcional, modo de falha, efeito, consequência e tarefa.

O quarto é a utilidade prática. O resultado precisa ajudar uma equipe real de manutenção, não apenas produzir um documento bonito.

Se esses critérios não forem atendidos, o projeto vira apenas mais uma interface com IA. A proposta aqui é diferente: usar IA para melhorar a disciplina do processo técnico.

## Próximos passos

Os próximos passos do projeto são:

1. escolher um ativo piloto;
2. estruturar um fluxo mínimo de análise;
3. criar uma interface simples;
4. testar a condução com dados reais ou realistas;
5. comparar a saída com uma análise manual;
6. revisar os prompts técnicos;
7. avaliar se o resultado melhora a documentação da decisão.

A partir disso, será possível decidir se o projeto deve evoluir para uma ferramenta mais robusta, com banco de dados, histórico de análises, exportação de relatórios e integração com outros processos de confiabilidade.

## Conclusão

A aplicação de LLMs em manutenção industrial precisa ser tratada com cuidado. Existe uma diferença grande entre gerar texto técnico e apoiar uma decisão técnica.

No caso da RCM, essa diferença é fundamental.

Um assistente de IA não deve decidir sozinho quais tarefas de manutenção devem ser aplicadas a um ativo. Mas pode ajudar a estruturar perguntas, registrar raciocínios, revisar lacunas e tornar o processo mais padronizado.

Esse é o propósito do projeto: explorar uma forma prática de combinar RCM, confiabilidade e IA generativa para apoiar equipes de manutenção naquilo que muitas vezes é mais difícil do que calcular indicadores — transformar conhecimento técnico em decisão documentada.
