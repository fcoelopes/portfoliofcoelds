---
title: "ArcPRESS — integridade de equipamentos sob pressão, do cadastro à evidência"
description: "Conheça o estágio atual do ArcPRESS: uma plataforma em desenvolvimento para organizar ativos, inspeções e evidências de integridade no contexto da NR-13."
pubDate: "2026-10-19"
type: "project"
category: "Software industrial e integridade de ativos"
status: "Em desenvolvimento"
readingTime: "6 min"
problem: "Documentos, inspeções, certificados e vencimentos de equipamentos sob pressão costumam estar espalhados em planilhas, pastas e sistemas desconectados."
application: "Gestão da integridade de caldeiras, vasos de pressão, tubulações, tanques e instrumentos de segurança no contexto da NR-13."
method: "Modelagem de ativos, regras de domínio, histórico de inspeções, evidências documentais e execução em campo."
value: "Reunir contexto técnico e rastreabilidade para apoiar a gestão de integridade, sem substituir a responsabilidade profissional."
stack: ["Python", "FastAPI", "React", "TypeScript", "PostgreSQL", "ArcInspect", "Docker", "MCP"]
tags: ["ArcPRESS", "NR-13", "Integridade de ativos", "Inspeção industrial", "Gestão de ativos", "Software"]
---

> **Qual é a situação de cada equipamento sob pressão — e quais evidências sustentam essa resposta?** Essa pergunta orienta o ArcPRESS.

## Por que o ArcPRESS existe

Em uma instalação industrial, as informações sobre um vaso de pressão, uma caldeira ou uma tubulação nem sempre estão no mesmo lugar. O cadastro do ativo está em um sistema, o prontuário em pastas, o certificado de calibração em outro arquivo, a inspeção em um laudo PDF e o prazo de uma recomendação em uma planilha.

O desafio não é simplesmente digitalizar documentos. É **relacionar o equipamento, suas características técnicas, os responsáveis, os eventos de inspeção e as evidências que justificam seu estado atual**.

O **ArcPRESS** nasce desse problema: uma plataforma web, em desenvolvimento, para gestão da integridade de equipamentos sob pressão no contexto da **NR-13**. Faz parte da família de aplicações industriais Arc, mas tem domínio próprio: enquanto o ArcPIE se concentra em instalações elétricas e NR-10, o ArcPRESS trabalha com ativos e processos associados à NR-13.

## A proposta: o ativo como ponto de partida

A premissa do projeto é simples: um prontuário útil não deveria ser apenas uma coleção de PDFs. Ele precisa ter contexto.

No ArcPRESS, o equipamento é o centro do modelo. A partir dele, o sistema pode relacionar instrumentos de segurança, certificados, inspeções, checklists, laudos, recomendações e estados operacionais. Regras de negócio ajudam a interpretar essas informações e a acompanhar situações que exigem atenção.

Isso não elimina a avaliação de engenharia. **O software organiza e aplica regras implementadas; decisões técnicas, inspeções e responsabilidades legais continuam com os profissionais habilitados.**

## O que já foi implementado

O estado atual do código contempla diferentes etapas do fluxo, ainda em evolução:

- **Cadastro e estrutura de ativos:** estabelecimentos, equipamentos, suas características, instrumentos de segurança, documentos e relacionamentos.
- **Regras de integridade e acompanhamento:** categorização de equipamentos, registros de calibração, acompanhamento de vencimentos, recomendações e estados operacionais, conforme os fluxos implementados.
- **Inspeções e evidências:** solicitações de inspeção, perfis e emissões de checklist, registro de execução, laudos, assinaturas e mecanismos de consulta ou validação documental.
- **ArcInspect:** aplicação específica para execução em campo, com fluxos de checklist, snapshots por emissão e recursos de trabalho offline e sincronização desenvolvidos no projeto.
- **Operação de serviços:** cadastro de clientes, serviços, contratos e ordens de serviço vinculadas às inspeções; geração de Relatório Diário de Obra (RDO) em PDF.
- **Controle de acesso e integrações:** organizações isoladas por tenant, autenticação e MFA, API, servidor MCP de consulta somente leitura e webhooks para eventos selecionados.

Essa lista descreve **capacidades presentes na implementação**, não uma promessa de que cada fluxo já tenha sido homologado em todos os cenários operacionais.

## Console e campo: dois contextos diferentes

O **console web** atende ao planejamento e à gestão: cadastrar ativos, organizar a documentação, acompanhar inspeções e consultar informações consolidadas.

Já o **ArcInspect** foi pensado para a rotina de quem executa a inspeção. Sua evolução recente inclui o uso de uma versão registrada do checklist por emissão, respostas em condições de conectividade limitada e tratamento de propostas de alteração de escopo. São recursos importantes porque a operação em campo nem sempre acompanha as condições ideais de um escritório.

O objetivo é aproximar planejamento, execução e evidência sem obrigar o profissional a reconstruir o histórico de uma inspeção depois do serviço.

## Arquitetura em construção

O backend é desenvolvido em **Python com FastAPI**, utilizando **PostgreSQL** para persistência. O console e o ArcInspect utilizam **React e TypeScript**. A infraestrutura do projeto é organizada com contêineres Docker, serviços de apoio e rotinas de implantação.

Duas decisões técnicas merecem destaque:

**Isolamento entre organizações.** O produto adota um modelo multi-tenant com controles de acesso e regras no banco de dados para separar informações de diferentes clientes.

**Integrações com limites explícitos.** O servidor MCP expõe consultas de domínio, sem autorizar agentes de IA a aprovar inspeções ou modificar dados críticos. Webhooks permitem propagar determinados eventos a sistemas externos, sem transformar uma notificação em aprovação técnica.

O desenvolvimento também contempla trilhas de auditoria, tratamento de solicitações de privacidade e mecanismos de verificação documental.

## Maturidade atual: o que significa “em desenvolvimento”

Em **19 de outubro de 2026**, o ArcPRESS reúne funcionalidades reais implementadas em backend, console web e aplicativo de campo, além de testes automatizados e infraestrutura de implantação.

Mas há uma diferença importante entre **existir no repositório**, **funcionar em testes** e **estar homologado para uso contínuo em produção**. Esta publicação documenta o primeiro grupo de evidências e parte do segundo; não anuncia uma implantação comercial estável, disponibilidade pública irrestrita ou certificação de conformidade com a NR-13.

Também não apresento números de redução de risco, produtividade ou economia: esses resultados dependerão de validação com usuários e operações reais.

## O que vem a seguir

As prioridades são consolidar os fluxos ponta a ponta de inspeção, qualificar cenários de sincronização e alteração de escopo, reforçar a estabilidade da implantação e testar a experiência com quem trabalha efetivamente com equipamentos sob pressão.

O aprendizado central do ArcPRESS é que **integridade não se resolve apenas armazenando documentos**. É necessário conectar o ativo, a regra aplicável, a atividade executada, a evidência produzida e a responsabilidade por cada decisão.

O projeto continua evoluindo, com uma orientação clara: **menos informação dispersa; mais contexto e rastreabilidade para decisões técnicas**.
