---
title: "Assistente para interpretação de diagramas elétricos industriais"
description: "Projeto de assistente técnico para interpretar diagramas elétricos industriais e apoiar leitura, inspeção e diagnóstico em manutenção."
pubDate: 2026-06-15
type: "project"
---

## Contexto

Diagramas elétricos industriais são documentos essenciais para manutenção, operação e diagnóstico de falhas. Eles mostram como motores, contatores, relés, proteções, botoeiras, sensores e painéis estão conectados e como o circuito deve funcionar.

Na prática, porém, muitos diagramas são difíceis de interpretar, principalmente quando estão em PDF, escaneados, desatualizados ou sem uma explicação associada. O objetivo deste projeto é criar um assistente que ajude a transformar esses diagramas em explicações claras, checklists e hipóteses de diagnóstico.

## Problema

Diagramas elétricos industriais são frequentemente difíceis de interpretar por técnicos iniciantes, equipes de manutenção, profissionais de PCM e até por engenheiros que não participaram do projeto original.

As principais dificuldades são:

* identificar componentes e suas funções;
* compreender tags como QF1, KM1, RT1, S0, S1, M1, KT1 etc.;
* entender a relação entre circuito de comando e circuito de potência;
* reconhecer lógica de selo, intertravamento, partida, parada e proteção;
* associar partes diferentes do mesmo equipamento lógico, como bobina, contatos principais e contatos auxiliares de KM1;
* transformar o diagrama em roteiro de inspeção ou diagnóstico;
* lidar com diagramas escaneados, antigos, incompletos ou sem explicação didática;
* depender excessivamente de profissionais experientes para leitura e troubleshooting.

## Abordagem

A solução será desenvolvida como um assistente técnico para apoiar a leitura de diagramas elétricos industriais.

A ideia é que o usuário envie um diagrama em imagem ou PDF e o sistema ajude a identificar os principais componentes, explicar a função provável do circuito, separar comando e potência, indicar proteções e sugerir pontos de verificação em caso de falha.

O projeto também pretende aproveitar técnicas de reconhecimento de diagramas e representação em grafos. Essa camada servirá para dar mais rastreabilidade à interpretação, permitindo que o assistente não apenas “descreva” o desenho, mas relacione componentes e conexões de forma mais estruturada.

O foco inicial será em circuitos industriais comuns, como partida direta de motores, partida estrela-triângulo, reversão de motor, circuitos com relés térmicos, contatores, botoeiras e intertravamentos.

## Ferramentas

As ferramentas previstas para o desenvolvimento inicial são:

* Python;
* Streamlit;
* OpenCV;
* PyMuPDF;
* PaddleOCR ou EasyOCR;
* NetworkX;
* Pydantic;
* SQLite;
* LLM API para geração de explicações;
* pytest para testes.

Em fases posteriores, poderão ser avaliadas ferramentas para detecção automática de símbolos, anotação de imagens e armazenamento em grafo, como YOLO, Roboflow, CVAT, FastAPI, React e Neo4j.

## Resultado esperado

O resultado esperado é um assistente capaz de apoiar a interpretação de diagramas elétricos industriais.

Na primeira versão, o sistema deverá ser capaz de:

* explicar circuitos industriais simples;
* identificar componentes principais;
* indicar a função provável de cada componente;
* diferenciar comando e potência;
* gerar uma sequência básica de funcionamento;
* sugerir pontos de inspeção;
* apoiar diagnósticos simples, como “motor não liga”.

Em versões futuras, a solução deverá evoluir para reconhecer componentes diretamente em imagens ou PDFs, gerar uma representação estruturada do circuito e produzir diagnósticos mais rastreáveis.

## Maturidade atual

O projeto está em fase de concepção e estruturação técnica.

Já foram definidos o problema, o público-alvo, a proposta de valor, o escopo inicial e o caminho de implementação. A decisão principal é começar por circuitos industriais simples e evoluir gradualmente para reconhecimento visual, representação em grafo e diagnóstico assistido.

## Próximos passos

Os próximos passos são:

* definir o modelo de representação dos circuitos;
* criar exemplos iniciais de partida direta e estrela-triângulo;
* implementar uma primeira interface em Streamlit;
* testar a geração de explicações técnicas;
* adicionar upload de imagem ou PDF;
* implementar OCR para leitura de tags;
* evoluir para reconhecimento de componentes;
* desenvolver o assistente de diagnóstico baseado na estrutura do circuito.
