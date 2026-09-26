---
title: "USPM + Bruss — decisão de manutenção entre condição do ativo e oportunidades operacionais"
description: "Framework que combina confiabilidade, condição do ativo, custos de manutenção e janelas operacionais para apoiar a decisão de quando intervir."
pubDate: 2026-09-26
type: "project"
category: "Maintenance Decision Analytics"
status: "Em desenvolvimento"
progress: 75
readingTime: "9 min"
problem: "Planos de manutenção normalmente tratam o melhor instante técnico e as oportunidades operacionais como se fossem a mesma decisão."
application: "Ativos industriais monitorados por condição, com histórico de falhas, custos de manutenção e janelas reais de parada."
method: "USPM integral + Weibull + confiabilidade condicionada + Opportunity Adapter + Bruss Odds Theorem."
value: "Separar a necessidade técnica do ativo da conveniência operacional e tornar explícito o custo e o risco de deslocar uma intervenção."
stack: ["Python", "Streamlit", "SciPy", "Weibull", "USPM", "Bruss"]
tags: ["Confiabilidade", "USPM", "Bruss", "Weibull", "Manutenção Preditiva", "Decision Analytics"]
---

## Contexto

Uma decisão de manutenção costuma misturar duas perguntas diferentes:

1. **quando o ativo deveria sofrer intervenção?**
2. **qual janela operacional vale a pena aproveitar?**

Essa diferença parece pequena, mas muda completamente a lógica da decisão.

Se um modelo de confiabilidade indica que a intervenção ótima está no dia 23, uma parada disponível no dia 25 pode ser interessante. Mas isso não significa que o ótimo técnico mudou para o dia 25. Significa apenas que existe uma oportunidade operacional próxima do ótimo que precisa ser avaliada.

O projeto **USPM + Bruss** nasceu para manter essas duas decisões separadas.

> Primeiro o ativo define quando deveria sofrer intervenção. Depois a operação avalia se vale aproveitar uma oportunidade.

## O problema

Na prática, decisões de preventiva e preditiva frequentemente dependem de uma combinação de fatores:

- histórico de falhas;
- condição atual do equipamento;
- custo de preventiva;
- custo de corretiva;
- custo de substituição;
- efeito imperfeito de intervenções anteriores;
- disponibilidade de equipes;
- duração esperada do reparo;
- janelas de parada do processo.

Ferramentas tradicionais costumam resolver apenas partes desse problema.

Um modelo de vida pode estimar confiabilidade, mas não necessariamente dizer quando intervir considerando custos e manutenção imperfeita. Um calendário de paradas pode mostrar oportunidades, mas não informa quanto custa antecipar ou postergar a manutenção. E uma decisão puramente operacional pode acabar sobrescrevendo a necessidade real do ativo.

## Abordagem

A arquitetura foi dividida em duas camadas.

### 1. USPM como motor técnico-econômico

O núcleo usa a política **Updated Sequential Predictive Maintenance — USPM**, proposta por You, Li, Meng e Ni.

O motor recebe:

- tempos até falha e censuras;
- distribuição Weibull estimada da população;
- sinais de condição do ativo atual;
- custos de manutenção;
- histórico de PM imperfeita;
- estado atual do ciclo.

A aplicação calcula uma sequência não uniforme de intervenções e busca minimizar a taxa de custo de manutenção:

$$
MCR = \frac{Q(t)}{J(t)}
$$

onde:

- `Q(t)` é o custo esperado restante;
- `J(t)` é o tempo operacional restante.

A saída principal é um baseline técnico:

- quando fazer a próxima intervenção;
- quantas preventivas ainda existem antes da substituição;
- custo esperado por unidade de tempo;
- confiabilidade até o ponto recomendado.

### 2. Oportunidades operacionais como camada externa

Depois que o USPM encontra o ótimo, as janelas de parada são avaliadas separadamente.

Para cada oportunidade, o sistema fixa a primeira intervenção naquela data e reotimiza o restante da sequência usando o mesmo motor USPM.

Assim é possível medir o custo de deslocar a manutenção:

$$
Regret_i =
\left[
\frac{MCR(O_i)}{MCR(t^*)}-1
\right]100
$$

Uma janela pode então ser filtrada por:

- aumento máximo de custo aceitável;
- confiabilidade mínima até a data;
- capacidade real de executar o serviço dentro da janela.

## Dados de vida e Weibull

Os parâmetros da distribuição não são digitados pelo usuário.

A aplicação recebe falhas e observações censuradas e estima automaticamente uma Weibull de dois parâmetros por máxima verossimilhança.

$$
R(t)=\exp\left[-\left(\frac{t}{\eta}\right)^\beta\right]
$$

Essa distribuição representa a vida da população e é usada principalmente nos ciclos futuros após a próxima intervenção.

## Condição do ativo atual

O ciclo atual não depende apenas da distribuição populacional.

A aplicação também aceita séries de sinais como:

- vibração;
- corrente;
- temperatura;
- pressão;
- potência;
- torque;
- outras variáveis preditivas.

Esses dados são convertidos em uma curva de confiabilidade condicionada do ativo atual.

Isso permite que dois equipamentos da mesma população tenham decisões diferentes quando um deles apresenta degradação mais acelerada.

## PM imperfeita

O modelo não assume que toda preventiva deixa o ativo "como novo".

O USPM usa dois fatores para representar o efeito da manutenção:

- `a_k`: alteração permanente da hazard após intervenções;
- `b_k`: idade residual após a PM.

Isso permite representar manutenção imperfeita e sequências de intervenção não uniformes.

## Tempos de reparo e MTTR

Para avaliar se uma oportunidade é realmente executável, a aplicação usa tempos reais de reparo.

O usuário lança ou importa os TTRs e o sistema calcula:

- MTTR;
- desvio-padrão;
- coeficiente de variação;
- probabilidade de o serviço caber em cada janela.

A probabilidade operacional é:

$$
p_i=P(TTR\le W_i)
$$

onde `W_i` é a duração disponível da oportunidade.

## Onde entra Bruss

Depois que uma oportunidade passa pelos filtros técnico-econômicos, o projeto pode usar o **Bruss Odds Theorem** como regra opcional de parada.

O objetivo não é permitir que Bruss altere o ótimo de manutenção.

Ele recebe apenas as oportunidades já consideradas admissíveis e trabalha sobre a probabilidade de execução de cada janela.

A arquitetura permanece:

```text
vida + condição + custos
          ↓
       USPM
          ↓
   baseline técnico
          ↓
avaliação das janelas
          ↓
 oportunidades admissíveis
          ↓
   Bruss opcional
```

## Interface

O projeto usa Streamlit, mas a interface foi desenhada para esconder a matemática quando ela não ajuda a decisão.

A visão principal mostra:

- recomendação de quando intervir;
- confiabilidade até a intervenção;
- custo esperado por dia;
- sequência de preventivas e substituição.

Detalhes econômicos e de confiabilidade ficam disponíveis sob demanda.

O objetivo é que a complexidade permaneça no motor, não na tela do gerente.

## O que já está implementado

O motor atual inclui:

- USPM integral;
- custo esperado completo `Q(t)/J(t)`;
- `C_m1` e `C_m2` separados;
- sequência ótima não uniforme;
- fatores `a_k` e `b_k`;
- otimização por número de intervenções;
- atualização sequencial da condição;
- Weibull com censura por MLE;
- ingestão de dados de condição;
- TTR, MTTR e variabilidade;
- avaliação de regret das oportunidades;
- Bruss desacoplado do USPM;
- suíte de testes matemáticos e arquiteturais;
- CI via GitHub Actions.

## Limitações atuais

O projeto ainda está em desenvolvimento.

Alguns pontos precisam de validação adicional antes de uso operacional:

- estimativa de `a_k` e `b_k` a partir de histórico real de manutenção;
- validação dos modelos prognósticos usados para gerar a confiabilidade condicionada;
- verificação das hipóteses necessárias para usar Bruss em oportunidades industriais;
- comparação com decisões reais de manutenção em ativos monitorados.

A extensão Bruss deve ser tratada como uma camada experimental de optimal stopping, não como parte do modelo USPM original.

## Referências principais

**USPM**

M.-Y. You, L. Li, G. Meng e J. Ni. *Cost-Effective Updated Sequential Predictive Maintenance Policy for Continuously Monitored Degrading Systems*. IEEE Transactions on Automation Science and Engineering, 2010.

**Bruss Odds Theorem**

F. T. Bruss. *Sum the Odds to One and Stop*. The Annals of Probability, 2000.

**Weibull**

W. Weibull. *A Statistical Distribution Function of Wide Applicability*. Journal of Applied Mechanics, 1951.

## Código

O projeto está disponível no GitHub:

[github.com/fcoelopes/uspmbruss](https://github.com/fcoelopes/uspmbruss)
