---
title: "Controle de EPIs — rastreabilidade de equipamentos de proteção individual em plantas industriais"
description: "Software para gestão, rastreabilidade e controle de entrega de EPIs, com conformidade à NR-6 e histórico auditável por colaborador."
pubDate: 2026-06-06
type: "project"
---

## Contexto

A NR-6 (Norma Regulamentadora 6) estabelece que o empregador é obrigado a fornecer EPI adequado ao risco e em perfeito estado de conservação, além de exigir comprovante de entrega assinado pelo trabalhador. Em plantas industriais com dezenas ou centenas de colaboradores e múltiplos turnos, esse controle é feito, na maioria dos casos, em fichas de papel ou planilhas — sem rastreabilidade real, sem alertas de validade e sem histórico consolidado.

A ausência de controle adequado cria dois problemas: risco operacional (colaborador sem EPI adequado) e risco legal (empresa sem comprovante em caso de fiscalização ou acidente).

## Problema

O controle manual de EPIs em ambientes industriais enfrenta:

- **Falta de rastreabilidade**: não há como saber rapidamente quais EPIs foram entregues a cada colaborador, quando e em que condição
- **Controle de validade inexistente**: EPIs com CA vencido (Certificado de Aprovação do INMETRO) continuam em uso sem que ninguém perceba
- **Ausência de histórico**: em caso de acidente ou fiscalização, não há como provar a entrega
- **Reposição reativa**: a solicitação de novos EPIs acontece quando o estoque acaba, não quando a demanda é previsível

## Abordagem

O sistema foi construído como uma aplicação web leve com quatro módulos:

1. **Cadastro**: colaboradores, EPIs (com número de CA, fabricante, validade do CA) e setores
2. **Entrega e devolução**: registro de cada movimentação com data, quantidade e assinatura digital ou confirmação do responsável
3. **Estoque**: controle de entrada, saída e nível de estoque por tipo de EPI, com alerta de reposição configurável
4. **Relatórios**: histórico por colaborador, por EPI e por setor; alertas de CAs próximos do vencimento; relatório de conformidade para auditoria

O foco foi em simplicidade de operação — o sistema precisa ser usado por técnicos de SSMA e almoxarifes, não por analistas de TI.

## Ferramentas

- **Python** — lógica de negócio e backend
- **Streamlit** — interface web sem necessidade de instalação nos computadores dos usuários
- **PostgreSQL** — banco de dados local (sem dependência de servidor externo)
- **Terraform** — provisionamento para deploy em ambiente de rede interna ou cloud privada

## Resultado esperado

Um sistema que qualquer empresa industrial possa implantar sem custo de licença e sem infraestrutura complexa — rodando em um computador de rede local ou em uma instância cloud básica. O benefício direto é a conformidade com NR-6 comprovável em auditoria e a eliminação do controle em papel.

Resultado secundário: dados de consumo de EPIs por setor e por período, que permitem negociar contratos de fornecimento com base em consumo real — não em estimativa.

## Maturidade atual

**Em produção — 40% concluído.**

O sistema está operacional com os módulos de cadastro, entrega, devolução e estoque funcionando. Está em uso em ambiente de teste com dados reais.

O módulo de relatórios está parcialmente implementado: o histórico por colaborador está disponível, mas os relatórios de conformidade para auditoria e os alertas automáticos de CA vencendo ainda estão em desenvolvimento.

## Próximos passos

- Finalizar o módulo de alertas de CA vencendo (notificação por e-mail ou painel de alertas)
- Implementar relatório de conformidade NR-6 exportável em PDF
- Adicionar controle de EPI coletivo (EPIc) além do individual
- Avaliar integração com sistemas de ponto eletrônico para cruzar entregas com registros de presença
- Documentar para replicação em outros ambientes industriais
