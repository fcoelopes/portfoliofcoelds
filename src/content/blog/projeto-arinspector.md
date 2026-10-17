---
title: "ARInspector — quando o equipamento passa a orientar a inspeção"
description: "Uma plataforma em desenvolvimento para conectar ativos físicos, contexto técnico e execução de inspeções por realidade aumentada, com Studio para autoria e Edge para o campo."
pubDate: "2026-10-17"
type: "project"
category: "Realidade aumentada e manutenção industrial"
status: "Em desenvolvimento"
readingTime: "7 min"
problem: "O técnico em campo precisa reunir identificação, procedimentos, limites e dados do equipamento que estão espalhados em diferentes fontes."
application: "Inspeções industriais, identificação de ativos, instruções contextuais e futura execução rastreável de checklists junto ao equipamento."
method: "Studio para modelar e publicar experiências; Edge para identificar o ativo e executar conteúdo contextual na câmera."
value: "Aproximar o conhecimento técnico do ponto de intervenção, reduzir a fragmentação de informações e construir evidências de execução."
stack: ["Python", "FastAPI", "PostgreSQL", "React", "TypeScript", "Vite", "QR", "ZXing", "Realidade Aumentada"]
tags: ["ARInspector", "RainInspector", "Realidade Aumentada", "Manutenção", "Inspeções", "Indústria 4.0"]
---

> **E se o próprio equipamento pudesse apresentar as informações necessárias para inspecioná-lo?** Essa é a provocação que orienta o ARInspector: aproximar o objeto físico, o contexto da manutenção e as ações do técnico no campo.

## O pitch

Uma inspeção não começa quando o técnico preenche um checklist. Ela começa quando ele precisa entender **onde está, o que está diante dele e o que precisa verificar**.

Na prática, parte desse conhecimento está num procedimento, parte num sistema de manutenção, parte numa etiqueta, parte na memória de quem conhece a instalação. O profissional precisa reunir tudo isso enquanto está diante de um motor, uma bomba ou um painel.

O **ARInspector** é a proposta de uma plataforma que leva esse contexto até o local da intervenção. Ao identificar um equipamento com a câmera, o técnico passa a ter acesso a uma ficha contextual; na visão completa, essa experiência evolui para instruções, checklists, registros de medições, anomalias e evidências — tudo vinculado ao ativo e à versão do procedimento executado.

A ideia não é simplesmente colocar textos por cima da câmera. É transformar a interação com o equipamento em uma **experiência de manutenção orientada, versionada e rastreável**.

*Nota de nomenclatura:* o projeto é desenvolvido no repositório interno `rainspector`, documentado também como **ARcXperience / RainInspector**. Nesta apresentação pública, usamos **ARInspector** como nome de referência do projeto, sem indicar uma mudança já realizada no código.

## O problema não é a ausência de informação

Em ambientes industriais, a informação frequentemente existe — mas não está disponível na hora, no formato e no contexto em que se precisa dela.

Identificar uma TAG pode ser simples. Saber quais componentes pertencem ao ativo, quais inspeções são aplicáveis, quais limites devem ser observados e como registrar um desvio é outra história.

Essa distância entre o equipamento físico e o conteúdo técnico gera consultas adicionais, interpretações inconsistentes e registros desconectados. A hipótese do ARInspector é que **uma interface contextual, próxima da execução, pode reduzir parte desse atrito**. Isso ainda precisa ser testado com usuários em campo; é um objetivo, não um ganho medido.

## Dois ambientes, responsabilidades diferentes

### Studio: onde a experiência é preparada

O **Studio** é o ambiente de planejamento e gestão. Nele, o responsável modela ativos e componentes, organiza sua identidade, define checklists e instruções, associa mecanismos de identificação e publica versões de uma experiência.

A unidade conceitual é a **AR Experience**: um pacote versionado que conecta o equipamento a conteúdos e interações permitidos.

Isso é importante porque uma etiqueta deve apenas identificar. Ela não precisa conter a ficha técnica inteira, nem determinar qual checklist será aplicado para sempre. O conteúdo pode evoluir na plataforma sem reimprimir cada QR Code.

### Edge: onde a experiência é executada

O **Edge** é o aplicativo de campo. Sua responsabilidade é identificar o alvo, carregar a versão publicada adequada, apresentar o conteúdo e registrar o trabalho executado.

O fluxo pretendido é direto:

**Identificar → reconhecer o contexto → consultar instruções → executar → registrar evidências → concluir e sincronizar.**

Um checklist pode solicitar estados como *Conforme*, *Anomalia* e *Não aplicável*, além de medições e fotografias, quando o fluxo completo estiver implementado.

O técnico não deve precisar de uma interface administrativa cheia de opções. A premissa é **menos é mais no campo**.

## Por que começar com QR Code e painel 2D?

O QR Code é um mecanismo acessível para associar o mundo físico a uma identidade digital. No projeto, ele carrega um identificador opaco; o backend resolve esse identificador e devolve o contexto apropriado.

Na camada visual inicial, um painel técnico é apresentado sobre a imagem capturada pela câmera. Isso já permite investigar questões práticas de leitura, legibilidade e acesso ao contexto.

Mas existe uma diferença fundamental entre **uma ficha apresentada sobre o vídeo** e **uma interface espacialmente ancorada ao equipamento**.

O painel 2D já é objeto de implementação e testes na aplicação web. Rastreamento espacial robusto, hotspots, setas, modelos 3D, animações e vistas explodidas permanecem como evoluções previstas. Não vamos chamar essa etapa inicial de AR 3D pronta.

O sistema também foi pensado para que, no futuro, outros identificadores — NFC, OCR ou visão computacional — possam substituir ou complementar o QR sem alterar a lógica central da inspeção.

## O que já foi construído

A implementação existente no repositório inclui componentes concretos, ainda que não constitua o fluxo completo de inspeção:

- **Backend Python / FastAPI:** domínio de equipamentos e identificadores, autenticação, endpoints, persistência e migrações;
- **Identificação e etiquetas:** criação de QR Codes, associação a equipamentos e exportação em SVG/PDF;
- **Interfaces administrativas:** cadastro, marcadores, lotes, associações e dados técnicos dos ativos;
- **Protótipo web com câmera:** leitura de QR e apresentação de ficha técnica contextual sobre vídeo;
- **Testes automatizados:** cobertura de operações de API e fluxos relevantes da interface.

A base Unity está prevista para uma futura camada de execução espacial, mas **o cliente Unity não está implementado**. O reconhecimento de objetos sem QR, a publicação completa de AR Experiences e a coleta integral de evidências do Edge também não devem ser anunciados como entregas.

## A arquitetura por trás da experiência

A plataforma separa quatro responsabilidades.

**Identificação** descobre qual ativo ou componente está diante do dispositivo. **Resolução de contexto** associa essa identidade aos dados corretos. **Experiência** define conteúdos, instruções e interações numa versão publicada. **Renderização** decide como apresentar esse conteúdo no dispositivo.

Essa separação permite experimentar diferentes renderizadores sem fazer o banco de checklists depender de Unity, Vuforia ou de um tipo específico de marcador.

O objetivo é que **Studio publique; Edge execute**. Uma versão publicada deve permanecer imutável para que, meses depois, seja possível compreender exatamente quais instruções estavam disponíveis numa inspeção.

## Os desafios que realmente importam

Para o ARInspector amadurecer, não basta produzir uma sobreposição visual atraente. Precisamos avaliar, em campo:

- se o identificador é lido de maneira consistente em condições reais de iluminação e distância;
- se o conteúdo é legível e útil sem distrair o técnico;
- como funcionam checklist, fotos e medições diante de conectividade instável;
- como preservar integridade das versões, rastreabilidade e sincronização;
- quais recursos espaciais efetivamente agregam valor em vez de complexidade.

É nessa validação prática que a experiência deixa de ser demonstração tecnológica e começa a se aproximar de uma ferramenta de manutenção.

## Próximos passos

O trabalho de desenvolvimento está orientado para fechar o ciclo entre **cadastro → checklist → experiência → publicação → execução → evidência**. A prioridade é implementar capacidades verticais que realmente funcionem, sem criar menus para endpoints ou fluxos que ainda não existem.

Posteriormente, poderemos investigar ancoragem espacial, reconhecimento visual de componentes e conteúdos 3D, sempre medindo sua contribuição para a execução.

## Conclusão

O ARInspector parte de uma pergunta aparentemente simples: **por que a informação necessária para cuidar de um equipamento ainda está tão distante dele?**

A resposta proposta é aproximar identificação, contexto, instrução e registro num único fluxo orientado ao campo.

O projeto continua em desenvolvimento. Seu valor será demonstrado não pelo número de recursos de realidade aumentada, mas pela capacidade de **ajudar alguém a executar uma inspeção com mais contexto, menos fricção e evidências confiáveis**.
