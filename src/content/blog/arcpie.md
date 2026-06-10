---
title: "Prontuário de Instalações Elétricas digital"
description: "O ArcPIE é uma plataforma SaaS multi-tenant de gestão do Prontuário de Instalações Elétricas (NR-10, itens 10.2.3, 10.2.4 e 10.2.5)"
pubDate: 2026-06-11
type: "project"
---

## Contexto

Toda indústria com mais de 75 kW é obrigada pela NR-10 a manter um Prontuário de Instalações Elétricas — e quase todas o mantêm morto: laudos em gavetas, certificados vencidos sem ninguém saber, estudos desatualizados desde a última mudança no painel. O ArcPIE modela a instalação elétrica do cliente — painéis, trabalhadores, EPIs — e gera o prontuário como consequência viva dela: quando o unifilar muda, o estudo de arco é invalidado sozinho; quando um treinamento vence, a autorização do eletricista cai sozinha; quando o ensaio da luva expira, ela aparece como indisponível sozinha. E tudo é verificável por QR: na etiqueta do painel, no crachá do eletricista, na bolsa da luva. O fiscal audita papéis. O ArcPIE audita a instalação — os papéis são gerados dela.

## Problema

A NR-10 exige que estabelecimentos com carga instalada superior a 75 kW constituam e mantenham o PIE — um conjunto de documentos técnicos que inclui esquemas unifilares, laudos de SPDA e aterramento, especificação e ensaios de EPIs/EPCs, comprovação de qualificação e autorização dos trabalhadores, certificações de áreas classificadas e o relatório técnico de inspeções com cronograma de adequações. Na prática, esse prontuário vive em pastas físicas e diretórios de rede: ninguém sabe o que está vencido, o estudo de arco não acompanha as mudanças da planta, e a empresa só descobre o problema na fiscalização — ou no acidente.

## Abordagem

O ArcPIE é uma plataforma SaaS multi-tenant de gestão do Prontuário de Instalações Elétricas (NR-10, itens 10.2.3, 10.2.4 e 10.2.5), construída sobre um motor de cálculo de energia incidente e um modelo digital da instalação.

Princípio de design: a instalação modelada é a fonte da verdade; o PIE é projeção derivada dela. Todo elemento segue o mesmo padrão — ativo → evidência vencível → status derivado → validação física por QR:


|   Ativo           |   Evidência vencível                           |                     Status derivado   |         QR físico            |
|-------------------|------------------------------------------------|---------------------------------------|------------------------------|
| Painel            | Estudo de arco (vence quando o unifilar muda)  | Etiqueta vigente/desatualizada        | Etiqueta NBR 17227 do painel |
| Trabalhador       | Qualificação + treinamento NR-10/SEP + ASO     | Termo de Autorização (cai em cascata) | Crachá do autorizado         |
| EPI/EPC isolante  | Laudo de ensaio de isolação (alínea e)         | Disponível/indisponível para uso      | Etiqueta do item             |



Experiência central: um checklist por instalação, organizado pelas alíneas da norma, onde o responsável marca itens anexando evidências — e vê a completude do prontuário subir em tempo real. A disponibilidade que a norma exige se materializa em dossiê PDF sob demanda (a "foto" do prontuário para o fiscal, com hash próprio) e validação pública por QR.

Garantias de auditabilidade: documentos imutáveis após aprovação (alterar = nova versão encadeada), trilha de auditoria append-only protegida no banco de dados, workflow de aprovação com responsável técnico e ART, e export completo do prontuário com manifesto de hashes — o cliente nunca fica refém da plataforma.

## Ferramentas

- **Python** — lógica de negócio e backend
- **PostgreSQL** — banco de dados local (sem dependência de servidor externo)

## Resultado esperado

Um sistema que qualquer empresa industrial possa implantar sem custo de licença e sem infraestrutura complexa — rodando em um computador de rede local ou em uma instância cloud básica. O benefício direto é a conformidade com NR-6 comprovável em auditoria e a eliminação do controle em papel.

Resultado secundário: dados de consumo de EPIs por setor e por período, que permitem negociar contratos de fornecimento com base em consumo real — não em estimativa.

## Maturidade atual

**Em produção — 60% concluído.**


## Próximos passos

- Validar o MVP;
- FAzer o deploy e disponibilizar para uso;
