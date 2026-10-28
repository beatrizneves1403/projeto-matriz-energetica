use matriz_energetica;

drop table if exists usinas_staging;

-- tabela de preparação (staging): tudo como texto para aceitar campos vazios
create table usinas_staging (
    cod_ceg                  varchar(40),
    nome                     varchar(255),
    uf                       char(2),
    tipo_geracao             char(3),
    fase                     varchar(30),
    fonte                    varchar(20),
    porte                    varchar(10),
    data_operacao            varchar(20),
    ano_operacao             varchar(10),
    potencia_outorgada_mw    varchar(30),
    potencia_fiscalizada_mw  varchar(30)
);

-- passo manual: importar dados/usinas_limpo.csv para usinas_staging 
-- (a versão utf-8 trava o assistente do workbench; esperado: 25042 linhas)

-- copiar para a tabela final, convertendo vazios em null e texto em número
truncate table usinas;

insert into usinas
select cod_ceg, nome, uf, tipo_geracao, fase, fonte, porte,
       nullif(data_operacao, ''),
       nullif(ano_operacao, ''),
       cast(potencia_outorgada_mw as decimal(12,5)),
       cast(potencia_fiscalizada_mw as decimal(12,5))
from usinas_staging;

-- conferência
select count(*) from usinas;                               -- 25042
select count(*) from usinas where data_operacao is null;   -- 2399
select round(sum(potencia_fiscalizada_mw), 1)
from usinas where fase = 'Operação';                       -- ~220658.9