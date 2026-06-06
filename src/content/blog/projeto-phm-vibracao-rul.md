---
title: "PHM e Vibração — estimativa de vida útil remanescente em equipamentos rotativos"
description: "Uso de dados de vibração, temperatura e corrente para estimar o RUL de equipamentos industriais com modelos de risco de sobrevivência."
pubDate: 2026-06-06
type: "project"
---

## Contexto

Equipamentos rotativos — bombas, compressores, ventiladores, motores — são responsáveis por grande parte das paradas não planejadas em plantas industriais. Técnicas de manutenção preditiva como análise de vibração e termografia são amplamente usadas, mas o diagnóstico ainda é majoritariamente qualitativo: "o nível de vibração subiu, vamos inspecionar".

O campo de Prognostics and Health Management (PHM) propõe ir além do diagnóstico: estimar quanto tempo o equipamento ainda tem antes de falhar — o Remaining Useful Life (RUL). Com essa informação, é possível planejar a intervenção no momento certo, sem antecipar desnecessariamente e sem deixar para tarde demais.

## Problema

A manutenção preditiva industrial ainda opera majoritariamente em modo reativo-adiantado: monitora-se a condição, e quando um limiar é ultrapassado, agenda-se a intervenção. Esse modelo:

- Não distingue entre uma tendência de degradação rápida e uma lenta
- Não considera o contexto operacional do equipamento (carga, temperatura ambiente, histórico)
- Gera intervenções desnecessárias quando o sinal é ruidoso
- Deixa escapar falhas quando a degradação é não-monotônica

Modelos de risco com covariáveis — como o Cox Proportional Hazards (Cox PH) — permitem incorporar dados de condição como covariáveis dinâmicas no modelo de sobrevivência, produzindo uma estimativa de RUL personalizada para cada equipamento em cada momento.

## Abordagem

O projeto explora a aplicação de modelos de sobrevivência a dados de monitoramento de condição:

1. **Coleta e engenharia de features**: extração de features de vibração (RMS, kurtosis, frequências características de rolamento) e outras variáveis de condição (temperatura, corrente)
2. **Modelo baseline**: Cox PH com covariáveis estáticas para estabelecer referência
3. **Modelo dinâmico**: Cox PH com covariáveis variantes no tempo (dados de condição em janelas temporais)
4. **Estimativa de RUL**: cálculo da função de sobrevivência condicional ao histórico observado de cada equipamento
5. **Interface de monitoramento**: visualização da curva de sobrevivência e alertas baseados em probabilidade de falha

A abordagem por modelos de sobrevivência foi escolhida por lidar naturalmente com dados censurados (equipamentos que não falharam ainda no período de observação) — um problema comum em datasets industriais.

## Ferramentas

- **Python** — processamento de sinais e modelagem
- **Streamlit** — dashboard de monitoramento e visualização de RUL
- **Terraform** — infraestrutura de deploy
- **Cox PH / Scikit-survival** — modelagem de risco com covariáveis
- **Datasets públicos** — CMAPSS (NASA), PRONOSTIA (FEMTO) para validação

## Resultado esperado

Um pipeline que recebe dados de monitoramento de condição de um equipamento rotativo e produz:

- Curva de sobrevivência atualizada com cada nova leitura
- Estimativa de RUL com intervalo de confiança
- Alerta quando a probabilidade de falha ultrapassa um limiar configurável

Aplicação direta: integração com sistemas de CMMS para geração automática de ordens de serviço preditivas baseadas em risco calculado — não em limiar fixo.

## Maturidade atual

**Pesquisa — 20% concluído.**

A revisão bibliográfica está concluída. O pipeline de processamento de features de vibração está em desenvolvimento com o dataset CMAPSS. O modelo Cox PH estático foi implementado e validado em dados sintéticos.

A principal lacuna atual é a construção do modelo dinâmico com covariáveis variantes no tempo e a validação com dados reais de equipamentos em operação.

## Próximos passos

- Implementar Cox PH com covariáveis variantes no tempo via `lifelines` ou `scikit-survival`
- Validar com dataset PRONOSTIA (rolamentos com degradação monitorada até a falha)
- Comparar com modelos alternativos: Random Survival Forest, Deep Survival (DeepHit)
- Construir o dashboard de monitoramento em Streamlit
- Estabelecer parceria com uma operação industrial para validação com dados reais
