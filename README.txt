# Matriz Energética Brasileira: análise com SQL e Python

Análise da capacidade de geração elétrica do Brasil a partir dos dados abertos da ANEEL (SIGA), usando **Python (pandas)** para limpeza e gráficos e **MySQL** para as consultas. O projeto responde perguntas sobre fontes de energia, estados, submercados do sistema elétrico e projetos em construção.

Os dados foram gerados pela ANEEL em **01/10/2026** e cobrem a **geração centralizada** (a geração distribuída, como painéis em telhados, não está incluída).

## Perguntas respondidas

1. Qual a capacidade instalada de cada fonte (hídrica, eólica, solar, fóssil, biomassa, nuclear)?
2. Como a capacidade se distribui entre os submercados (Sudeste/CO, Sul, Nordeste e Norte)?
3. De que fontes é feita a matriz de cada submercado?
4. Quanta potência entrou em operação a cada ano?
5. Quais estados lideram em hídrica e em solar?
6. Para onde o sistema está crescendo (projetos em construção)?

## Principais descobertas

- **Contar usinas e somar potência contam histórias opostas.** A solar tem 76% das usinas em operação, mas só 10,7% da potência (23.615 MW). A hídrica tem 6% das usinas e 50% da potência (110.227 MW).
- **Muitas usinas são minúsculas.** 71% das usinas em operação são "micro" (até 75 kW) e somam apenas 29 MW. Já as 223 usinas de grande porte (1% do total) concentram 60% da potência.
- **Sudeste/Centro-Oeste lidera em capacidade (41%)**, seguido pelo Nordeste (29%), Norte (15%) e Sul (15%). O Norte tem 60% das usinas, mas só 15% da potência.
- **O Nordeste concentra cerca de 92% da eólica do país** (32.179 de 34.937 MW). Hídrica domina o Norte, o Sul e o Sudeste/CO.
- **A solar cresceu muito recentemente.** Os cinco anos com mais potência solar entrando em operação são todos de 2022 a 2026 e somam cerca de 80% da potência solar do país. O pico de 2016 na série geral corresponde a Belo Monte (11.233 MW).
- **Estados líderes mudam conforme a fonte.** Em hídrica: PA, PR, SP, MG e RO (67% do total). Em solar: MG, BA, PI, CE e RN (79%), com Minas Gerais sozinha respondendo por cerca de 37%.
- **O que vem por aí é quase todo solar e eólico.** Os 2.244 projetos em construção ou não iniciados somam 96.298 MW de potência outorgada: 75% solar, 17% eólica, e 65% no Nordeste.

## Gráficos

![Participação de cada fonte no total de usinas e na potência](imagens/grafico_fonte.png)
![Composição da potência instalada por submercado](imagens/grafico_submercado.png)
![Potência que entrou em operação por ano e por fonte (hídrica, eólica e solar)](imagens/grafico_entrada_por_ano.png)
![Potência acumulada em operação por fonte](imagens/grafico_acumulada.png)
![Potência outorgada de projetos não operacionais, por submercado e fonte](imagens/grafico_projetos.png)

## Tecnologias

- Python 3, pandas, NumPy, SQLAlchemy, PyMySQL, matplotlib e Jupyter
- MySQL 8 (consultas com `join`, `group by`, filtros e ordenação)
- Git e GitHub

## Estrutura do projeto

projeto-matriz-energetica/
├── dados/          arquivos de dados (o CSV bruto não é versionado)
├── notebooks/      exploração e limpeza, conexão com o banco e gráficos
├── sql/            scripts numerados, na ordem de execução
├── imagens/        gráficos gerados
├── requirements.txt
└── README.md


## Como reproduzir

1. Clone o repositório e crie o ambiente virtual:

   
   python -m venv venv
   venv\Scripts\activate.bat
   pip install -r requirements.txt
   

2. Baixe o CSV de empreendimentos de geração (SIGA) no portal de dados abertos da ANEEL (dadosabertos.aneel.gov.br) e salve em `dados/` como `siga-empreendimentos-geracao.csv`.
3. Rode `notebooks/01_exploracao.ipynb`, que explora e limpa os dados e gera o CSV limpo.
4. No MySQL, rode os scripts `sql/00` a `sql/03` em ordem numérica. Entre a criação da tabela de staging e a cópia para a tabela final, há um passo manual: importar o CSV limpo (no MySQL Workbench: botão direito em `usinas_staging` > *Table Data Import Wizard*). Se houver erro de codificação, use a cópia `usinas_limpo_ansi.csv`, gerada no final do notebook de limpeza.
5. Rode `sql/04_consultas.sql` para ver as análises em SQL.
6. Rode `notebooks/03_graficos.ipynb` para gerar os gráficos em `imagens/`. Ele pede a senha do MySQL e não a salva no arquivo. O `notebooks/02_banco_mysql.ipynb` só testa a conexão.

## Decisões e limitações

- **Uma linha por usina.** Três códigos apareciam duplicados (mesma usina com dois tipos de outorga, Autorização e Concessão), e foi mantida uma linha de cada para não contar a potência em dobro.
- **Medida principal: potência em MW.** Para usinas em operação, usa-se a potência fiscalizada. Para projetos em construção, a outorgada, porque a fiscalizada é zero.
- **Projetos não iniciados.** 2.099 dos 2.244 projetos estão em "construção não iniciada". Os números mostram potência **autorizada**, e não uma previsão do que será construído.
- **Porte das usinas.** Criado a partir da potência outorgada: micro (até 75 kW), pequena (até 5 MW), média (até 100 MW) e grande (acima disso). Os cortes são uma escolha do projeto.
- **Datas.** A ANEEL usa o ano 1900 como valor de preenchimento. Essas datas viraram vazias: 2.399 usinas ficaram sem data, sendo 156 em operação (cerca de 500 MW, 0,2% do total). Elas ficam de fora das análises por ano.
- **Potência atribuída ao ano de início.** A base coloca a potência inteira da usina no ano em que ela começou a operar, mesmo que tenha entrado em etapas. Isso explica o pico de 2016 (Belo Monte).
- **Submercados por estado.** Cada usina é associada ao submercado pelo seu estado, o que é uma simplificação. Acre e Rondônia pertencem ao Sudeste/CO por razões elétricas, e Roraima foi interligado ao SIN em 2026 e aqui está no Norte (a confirmar no ONS). Amazonas e Amapá têm partes isoladas do sistema.
- **2026 é um ano parcial.** Os dados vão até 01/10/2026, então nos gráficos por ano o último ponto está incompleto e não deve ser comparado com os anos fechados.
- **Só geração centralizada.** A geração distribuída (painéis em telhados) não está incluída.

## Fonte dos dados

ANEEL, Sistema de Informações de Geração (SIGA), dados abertos: https://dadosabertos.aneel.gov.br

## Autora

Beatriz Neves Ferreira de Paula
[Linkedin](https://linkedin.com/in/beatrizneves1403) · [GitHub](https://github.com/beatrizneves1403) · [Contato] (bianeves1403@gmail.com)